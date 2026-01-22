#!/usr/bin/env python3
"""Load PyTorch .pt files without requiring torch installation."""
import pickle
import zipfile
import io
import sys
import types
import pathlib
import debugpy


class _DummyClass:
    """Generic dummy that accepts any constructor args and stores state."""
    def __init__(self, *args, **kwargs):
        self._args = args
        self._kwargs = kwargs

    def __setstate__(self, state):
        if isinstance(state, dict):
            self.__dict__.update(state)
        else:
            self._state = state

    def __reduce_ex__(self, protocol):
        return (self.__class__, self._args, self.__dict__)

    def __repr__(self):
        cls_name = self.__class__.__name__
        if cls_name == "_DummyClass":
            cls_name = getattr(self, "__module__", "unknown") + ".dummy"
        attrs = {k: v for k, v in self.__dict__.items() if not k.startswith("_")}
        if attrs:
            return f"{cls_name}({attrs})"
        return f"{cls_name}()"


class TensorStorage:
    """Mock storage that holds raw tensor data."""
    def __init__(self, dtype, data=None, size=0):
        self.dtype = dtype
        self.data = data
        self.size = size

    def __repr__(self):
        return f"TensorStorage(dtype={self.dtype}, size={self.size}, has_data={self.data is not None})"


def _rebuild_tensor_v2(storage, storage_offset, size, stride, requires_grad, backward_hooks, metadata=None):
    return {
        "_type": "tensor",
        "storage": storage,
        "storage_offset": storage_offset,
        "size": size,
        "stride": stride,
        "requires_grad": requires_grad,
    }


def _rebuild_parameter(*args, **kwargs):
    return {"_type": "parameter", "args": args}


def _rebuild_parameter_with_state(*args, **kwargs):
    return {"_type": "parameter_with_state", "args": args}


def _create_fake_torch_module():
    """Create a fake torch module hierarchy."""
    torch = types.ModuleType("torch")
    torch._utils = types.ModuleType("torch._utils")
    torch.cuda = types.ModuleType("torch.cuda")
    torch.nn = types.ModuleType("torch.nn")
    torch.nn.parameter = types.ModuleType("torch.nn.parameter")
    torch.storage = types.ModuleType("torch.storage")

    torch._utils._rebuild_tensor_v2 = _rebuild_tensor_v2
    torch._utils._rebuild_parameter = _rebuild_parameter
    torch._utils._rebuild_parameter_with_state = _rebuild_parameter_with_state
    torch._utils._rebuild_device_tensor_v2 = _rebuild_tensor_v2

    storage_types = {
        "FloatStorage": "float", "DoubleStorage": "double", "HalfStorage": "half",
        "BFloat16Storage": "bfloat16", "IntStorage": "int", "LongStorage": "long",
        "ShortStorage": "short", "CharStorage": "char", "ByteStorage": "byte",
        "BoolStorage": "bool", "ComplexFloatStorage": "complexfloat",
        "ComplexDoubleStorage": "complexdouble", "TypedStorage": "typed",
        "UntypedStorage": "untyped",
    }

    for storage_name, dtype in storage_types.items():
        cls = type(storage_name, (), {"_dtype": dtype})
        setattr(torch, storage_name, cls)
        setattr(torch.cuda, storage_name, cls)

    torch.storage.TypedStorage = type("TypedStorage", (), {"_dtype": "typed"})
    torch.storage.UntypedStorage = type("UntypedStorage", (), {"_dtype": "untyped"})

    torch.Tensor = _DummyClass
    torch.nn.Parameter = _DummyClass
    torch.nn.parameter.Parameter = _DummyClass
    torch.Size = tuple

    return torch


class MockUnpickler(pickle.Unpickler):
    """Unpickler that mocks torch, tbp, and any other missing modules."""

    _class_cache = {}

    def __init__(self, file, fake_torch, zip_file=None, zip_prefix=""):
        super().__init__(file)
        self._fake_torch = fake_torch
        self._zip_file = zip_file
        self._zip_prefix = zip_prefix
        self._loaded_storages = {}

    def persistent_load(self, saved_id):
        if not isinstance(saved_id, tuple):
            raise pickle.UnpicklingError(f"Unexpected persistent id: {saved_id}")

        typename = saved_id[0]

        if typename == "storage":
            storage_type, key, location, numel = saved_id[1:]
            dtype = getattr(storage_type, "_dtype", "unknown")

            if key in self._loaded_storages:
                return self._loaded_storages[key]

            data = None
            if self._zip_file is not None:
                data_path = f"{self._zip_prefix}data/{key}"
                try:
                    data = self._zip_file.read(data_path)
                except KeyError:
                    pass

            storage = TensorStorage(dtype=dtype, data=data, size=numel)
            self._loaded_storages[key] = storage
            return storage

        elif typename == "module":
            _, module_name, class_name = saved_id
            return self.find_class(module_name, class_name)

        else:
            raise pickle.UnpicklingError(f"Unknown persistent id type: {typename}")

    def _get_dummy_class(self, module, name):
        """Get or create a cached dummy class for the given module.name."""
        key = (module, name)
        if key not in self._class_cache:
            self._class_cache[key] = type(name, (_DummyClass,), {"__module__": module})
        return self._class_cache[key]

    def find_class(self, module, name):
        if module.startswith("torch"):
            parts = module.split(".")
            obj = self._fake_torch
            for part in parts[1:]:
                obj = getattr(obj, part, None)
                if obj is None:
                    return self._get_dummy_class(module, name)
            result = getattr(obj, name, None)
            if result is not None:
                return result
            return self._get_dummy_class(module, name)

        try:
            return super().find_class(module, name)
        except (ModuleNotFoundError, AttributeError):
            return self._get_dummy_class(module, name)


def load_pt_without_torch(data_path: str):
    """Load a .pt file without torch or other dependencies installed."""
    fake_torch = _create_fake_torch_module()

    original_modules = {}
    fake_modules = {
        "torch": fake_torch,
        "torch._utils": fake_torch._utils,
        "torch.cuda": fake_torch.cuda,
        "torch.nn": fake_torch.nn,
        "torch.nn.parameter": fake_torch.nn.parameter,
        "torch.storage": fake_torch.storage,
    }

    for name, mod in fake_modules.items():
        original_modules[name] = sys.modules.get(name)
        sys.modules[name] = mod

    try:
        path = pathlib.Path(data_path)

        if zipfile.is_zipfile(path):
            with zipfile.ZipFile(path, "r") as zf:
                pkl_files = [f for f in zf.namelist() if f.endswith("data.pkl")]
                if not pkl_files:
                    raise ValueError(f"No data.pkl found in {data_path}")

                pkl_path = pkl_files[0]
                prefix = pkl_path[:-8]

                pkl_data = zf.read(pkl_path)
                unpickler = MockUnpickler(
                    io.BytesIO(pkl_data),
                    fake_torch,
                    zip_file=zf,
                    zip_prefix=prefix,
                )
                return unpickler.load()
        else:
            with open(path, "rb") as f:
                return MockUnpickler(f, fake_torch).load()

    finally:
        for name, mod in original_modules.items():
            if mod is None:
                sys.modules.pop(name, None)
            else:
                sys.modules[name] = mod


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python pt_loader.py <path_to_pt>")
        sys.exit(1)

    p = pathlib.Path(sys.argv[1])
    data = load_pt_without_torch(str(p))

    debugpy.breakpoint()

    print(f"[pt-dap] Loaded: {p} type={type(data).__name__}")
    if isinstance(data, dict):
        print(f"[pt-dap] Keys: {list(data.keys())[:20]}")

-- lua/scripts/json_dap_explorer.lua
local M = {}

local function open_dap_view()
    -- If you use nvim-dap-view:
    if pcall(vim.cmd, "DapViewOpen") then return end
    -- Fallback to nvim-dap-ui (if you have it)
    pcall(function()
        require("dapui").open()
    end)
end

local function ensure_python_adapter()
    local dap = require("dap")
    if dap.adapters.python then return end
    dap.adapters.python = {
        type = "executable",
        command = vim.fn.exepath("python") or "python",
        args = { "-m", "debugpy.adapter" },
    }
end

local function write_temp_loader(json_path)
    local cache_dir = vim.fn.stdpath("cache")
    local tmp_py = cache_dir .. "/json_dap_debug.py"
    local py = ([[
import json, pathlib, debugpy
from json import JSONDecodeError

def load_json_smart(path):
    """Load normal JSON or newline-delimited JSON (one JSON per line)."""
    with open(path, "r", encoding="utf-8") as f:
        try:
            # Normal single JSON object or array
            return json.load(f)
        except JSONDecodeError:
            # Fallback to per-line JSON
            f.seek(0)
            objs = []
            as_dict = {}
            count = 0
            for _, line in enumerate(f):
                line = line.strip()
                if not line:
                    continue
                obj = json.loads(line)
                objs.append(obj)
                if isinstance(obj, dict) and len(obj) == 1:
                    # Mirror your chunked style: store the inner value under the line index
                    (k, v), = obj.items()
                    as_dict[k] = v
                    count += 1
            if count == len(objs) and count > 0:
                return as_dict
            return objs

p = pathlib.Path(r"%s")
data = load_json_smart(str(p))

debugpy.breakpoint()

# Helpful summary for the console
print(f"[json-dap] Loaded: {p} type={type(data).__name__} size={len(data)}")
]]):format(json_path)

    vim.fn.writefile(vim.split(py, "\n"), tmp_py)
    return tmp_py
end

local function debug_json_file(json_path)
    ensure_python_adapter()
    local dap = require("dap")
    local program = write_temp_loader(json_path)
    dap.run({
        type = "python",
        request = "launch",
        name = "Debug JSON: " .. vim.fn.fnamemodify(json_path, ":t"),
        program = program,
        console = "integratedTerminal",
        justMyCode = false,
        cwd = vim.fn.getcwd(),
        python = vim.fn.exepath("python"),
    })
    open_dap_view()
end

function M.pick_and_debug(opts)
    opts = opts or {}
    local ok, pickers = pcall(require, "telescope.pickers")
    if not ok then
        vim.notify("telescope.nvim not found", vim.log.levels.ERROR)
        return
    end
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- Build file list: prefer `fd`, else use plenary’s file finder
    local entries
    if vim.fn.executable("fd") == 1 then
        local cmd = { "fd", "--type", "f", "--extension", "json", "." }
        entries = function(prompt, process_result, _)
            local Job = require("plenary.job")
            Job:new({
                command = cmd[1],
                args = { unpack(cmd, 2) },
                cwd = opts.cwd or vim.loop.cwd(),
                on_exit = function(j)
                    for _, line in ipairs(j:result()) do
                        if prompt == nil or prompt == "" or line:lower():find(prompt:lower(), 1, true) then
                            process_result({
                                value = line,
                                path = (opts.cwd or vim.loop.cwd()) .. "/" .. line,
                                ordinal =
                                    line,
                                display = line
                            })
                        end
                    end
                end,
            }):start()
        end
    else
        -- Fallback: use Telescope’s builtin file finder and filter in previewer
        entries = require("telescope.finders").new_oneshot_job(
            { "sh", "-c", [[find . -type f -name "*.json" | sed 's#^\./##']] },
            { cwd = opts.cwd or vim.loop.cwd() }
        )
    end

    pickers
        .new(opts, {
            prompt_title = "Pick a JSON file to debug",
            finder = (type(entries) == "function") and { results = {}, fn_command = entries } or entries,
            sorter = conf.generic_sorter(opts),
            previewer = conf.file_previewer(opts),
            attach_mappings = function(prompt_bufnr, _)
                local function run_debug()
                    local entry = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    local path = entry.path or entry.value or entry[1]
                    debug_json_file(path)
                end
                -- Replace default select action so it doesn't open a buffer
                actions.select_default:replace(run_debug)
                -- Optional: also map <C-x> and <C-v> to same behavior
                vim.keymap.set({ "i", "n" }, "<C-x>", run_debug, { buffer = prompt_bufnr })
                vim.keymap.set({ "i", "n" }, "<C-v>", run_debug, { buffer = prompt_bufnr })
                return true
            end,
        })
        :find()
end

return M

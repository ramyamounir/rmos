-- lua/scripts/json_dap_explorer.lua
local M = {}

-- Directory containing the loader scripts
local script_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

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

local function get_loader_for_extension(ext)
    local loaders = {
        json = script_dir .. "/json_loader.py",
        pt = script_dir .. "/pt_loader.py",
    }
    return loaders[ext]
end

local function debug_data_file(file_path)
    ensure_python_adapter()

    local ext = vim.fn.fnamemodify(file_path, ":e")
    local loader = get_loader_for_extension(ext)

    if not loader then
        vim.notify("Unsupported file type: " .. ext, vim.log.levels.ERROR)
        return
    end

    if vim.fn.filereadable(loader) ~= 1 then
        vim.notify("Loader script not found: " .. loader, vim.log.levels.ERROR)
        return
    end

    local dap = require("dap")
    dap.run({
        type = "python",
        request = "launch",
        name = "Debug: " .. vim.fn.fnamemodify(file_path, ":t"),
        program = loader,
        args = { file_path },
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

    local cwd = opts.cwd or vim.loop.cwd()
    local finder

    if vim.fn.executable("fd") == 1 then
        finder = finders.new_oneshot_job(
            { "fd", "--type", "f", "-e", "json", "-e", "pt", "." },
            { cwd = cwd }
        )
    else
        finder = finders.new_oneshot_job(
            { "find", ".", "-type", "f", "(", "-name", "*.json", "-o", "-name", "*.pt", ")" },
            { cwd = cwd }
        )
    end

    pickers
        .new(opts, {
            prompt_title = "Pick a data file to debug (json/pt)",
            finder = finder,
            sorter = conf.generic_sorter(opts),
            previewer = conf.file_previewer(opts),
            attach_mappings = function(prompt_bufnr, _)
                local function run_debug()
                    local entry = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    local path = entry.path or entry.value or entry[1]
                    -- Make path absolute if relative
                    if not path:match("^/") then
                        path = cwd .. "/" .. path
                    end
                    debug_data_file(path)
                end
                actions.select_default:replace(run_debug)
                vim.keymap.set({ "i", "n" }, "<C-x>", run_debug, { buffer = prompt_bufnr })
                vim.keymap.set({ "i", "n" }, "<C-v>", run_debug, { buffer = prompt_bufnr })
                return true
            end,
        })
        :find()
end

return M

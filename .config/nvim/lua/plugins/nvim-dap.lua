local dependencies = {
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
        end,
    },
    {
        "jbyuki/one-small-step-for-vimkind",
    },
    {
        "igorlfs/nvim-dap-view",
        opts = {
            winbar = {
                show = true,
                sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
                default_section = "watches",
                controls = {
                    enabled = true,
                    position = "left",
                    buttons = {
                        "play",
                        "step_into",
                        "step_over",
                        "step_out",
                        "run_last",
                        "terminate",
                    },
                },
            },
            windows = {
                height = 12,
                terminal = {
                    position = "right",
                    start_hidden = false,
                    hide = {},
                },
            },
            switchbuf = "useopen",
        },
    },
    {
        "rcarriga/cmp-dap",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" }
                }
            })
        end,
    },
    {
        "LiadOz/nvim-dap-repl-highlights",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-dap-repl-highlights").setup()
        end,
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        config = function()
            require("telescope").load_extension("dap")
        end,
    },
}

local function config()
    local dap = require("dap")
    local dap_python = require("dap-python")
    local dap_view = require("dap-view")

    dap_python.test_runner = "pytest"
    dap_python.test_runners.pytest = function(classnames, methodname)
        local path = vim.fn.expand('%:p')
        local test_path = table.concat(vim.iter({ path, classnames, methodname }):flatten(2):totable(), '::')
        return 'pytest', { '-s', '-n', '1', test_path } -- Enable single worker for debugging (more efficient)
    end

    local project_root = vim.env.PROJECT_ROOT or vim.fn.getcwd()
    require("dap.ext.vscode").load_launchjs(project_root .. "/launch.json", { python = { "python" } })

    -- BASH DEBUGGER
    dap.configurations.sh = {
        {
            type = 'bashdb',
            request = 'launch',
            name = "Launch file",
            pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
            pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
            file = "${file}",
            program = "${file}",
            cwd = '${workspaceFolder}',
            pathCat = "cat",
            pathBash = "/bin/bash",
            pathMkfifo = "mkfifo",
            pathPkill = "pkill",
            args = {},
            env = {},
            terminalKind = "integrated",
        }
    }
    dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
    }

    -- LUA DEBUGGER
    dap.configurations.lua = {
        {
            type = 'nlua',
            request = 'attach',
            name = "Attach to running Neovim instance",
        }
    }
    dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    vim.keymap.set('n', '<leader>dL', function()
        require "osv".launch({ port = 8086 })
    end, { desc = "Debug: Start Lua Server", noremap = true })


    -- dap.configurations.python = {
    --     {
    --         type = "python",
    --         request = "launch",
    --         name = "Launch current file with args",
    --         program = "${file}",
    --         args = { "foo", "bar" },
    --         console = "integratedTerminal",
    --     },
    --     {
    --         type = "python",
    --         request = "launch",
    --         name = "Run my_script.py with input",
    --         program = "${workspaceFolder}/scripts/my_script.py",
    --         args = { "--input", "data.txt", "--debug" },
    --         console = "integratedTerminal",
    --     },
    --     {
    --         type = "python",
    --         request = "launch",
    --         name = "Run as module",
    --         module = "mymodule",
    --         args = { "--config", "cfg.yaml" },
    --         console = "integratedTerminal",
    --     },
    -- }

    vim.fn.sign_define("DapBreakpoint", {
        text = "🛑",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
        text = "▶️",
        texthl = "DapStopped",
        linehl = "Visual",
        numhl = "",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
        text = "🟡",
        texthl = "DapBreakpointCondition",
        linehl = "",
        numhl = "",
    })
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#E5C07B" })

    -- These are listeners to open and close the debugger view on hooks
    dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
    dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
    dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
    dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end

    -- Keymaps
    vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<Leader>dC", dap.run_to_cursor, { desc = "Debug: Run to cursor" })
    vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<Leader>dO", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>dr", function()
        vim.cmd("Direnv reload")
        dap.run_last()
    end, { desc = "Debug: Run Last" })
    vim.keymap.set("n", "<Leader>dd", function() dap_view.toggle() end, { desc = "Debug: Toggle DAP View" })
    vim.keymap.set("n", "<Leader>dx", function() dap.clear_breakpoints() end, { desc = "Debug: Clear breakpoints" })
    vim.keymap.set("n", "<Leader>dl", function()
        vim.cmd("Direnv reload")
        require("telescope").extensions.dap.configurations()
    end, { desc = "Debug: Choose Configuration" })
    vim.keymap.set("n", "<Leader>dq", function()
        dap.clear_breakpoints()
        dap_view.close(true)
        dap.terminate()
    end, { desc = "Debug: Quit and Clear Breakpoints" })
    vim.keymap.set("n", "<leader>dw", "<cmd>DapViewWatch<cr>", {
        desc = "DAP: Add cursor variable to expressions",
    })

    -- nvim-dap-python unit testing keybindings
    vim.keymap.set("n", "<leader>dt", function()
        dap_python.test_method()
    end, { desc = "Debug test method under cursor" })

    -- move region to repl
    vim.keymap.set("x", "<leader>dm", function()
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end

        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        dap.repl.open()
        dap.repl.execute("\n" .. table.concat(lines, "\n") .. "\n")

        -- Exit visual mode
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

        -- Switch to DAP REPL and enter insert mode
        vim.defer_fn(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "dap-repl" then
                    vim.api.nvim_set_current_win(win)
                    vim.api.nvim_feedkeys("i", "n", true)
                    break
                end
            end
        end, 100)
    end, { desc = "Send selection to DAP REPL" })
end


return {
    dependencies = dependencies,
    config = config
}

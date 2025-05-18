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

    local project_root = vim.env.PROJECT_ROOT or vim.fn.getcwd()
    require("dap.ext.vscode").load_launchjs(project_root .. "/launch.json", { python = { "python" } })

    -- BASH DEBUGGER
    dap.configurations.sh = {
        {
            type = 'bashdb',
            request = 'launch',
            name = "Launch file",
            showDebugOutput = true,
            pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
            pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
            trace = true,
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
    end, { noremap = true })


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
    -- dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
    -- dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
    -- dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
    -- dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end

    -- Keymaps
    vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<Leader>dO", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>dr", dap.run_last, { desc = "Debug: Run Last" })
    vim.keymap.set("n", "<Leader>dd", function() dap_view.toggle() end, { desc = "Debug: Toggle DAP View" })
    vim.keymap.set("n", "<Leader>dx", function() dap.clear_breakpoints() end, { desc = "Debug: Clear breakpoints" })
    vim.keymap.set("n", "<Leader>dl", function()
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
    vim.keymap.set("n", "<leader>dT", function()
        dap_python.test_class()
    end, { desc = "Debug test class under cursor" })
    vim.keymap.set("v", "<leader>ds", function()
        dap_python.debug_selection()
    end, { desc = "Debug selected code" })
end


return {
    dependencies = dependencies,
    config = config
}

local dependencies = {
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
        end,
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
    local dap_view = require("dap-view")

    local project_root = vim.env.PROJECT_ROOT or vim.fn.getcwd()
    require("dap.ext.vscode").load_launchjs(project_root .. "/launch.json", { python = { "python" } })

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
        dap_view.close(true)    -- Close the UI and terminal
        dap.clear_breakpoints() -- Remove all breakpoints
        dap.terminate()         -- Stop the debug adapter
    end, { desc = "Debug: Quit and Clear Breakpoints" })
end


return {
    dependencies = dependencies,
    config = config
}

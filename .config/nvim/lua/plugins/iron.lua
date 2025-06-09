local function config(plugins, opts)
    local status_ok, iron = pcall(require, "iron.core")
    if not status_ok then
        return
    end

    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
        config = {
            scratch_repl = true,
            repl_definition = {
                python = {
                    command = {
                        "ipython",
                        "-i",
                        "--quiet",
                        "--no-banner",
                        "--no-tip",
                        "--no-autoindent",
                        "--no-confirm-exit",
                        vim.fn.stdpath("config") .. "/lua/plugins/mason/dap/repl/ipython.py"
                    },
                    format = common.bracketed_paste_python,
                },
                -- sh = {
                --     command = { "sh" },
                --     format = common.bracketed_paste,
                -- },
                lua = {
                    command = { "lua" },
                    format = common.bracketed_paste,
                },
            },
            repl_open_cmd = view.split.vertical.botright(50),
        },
        repl_filetype = function(bufnr, ft)
            return ft
        end,
        keymaps = {
            send_motion = "<Leader>vc",
            visual_send = "<Leader>vl",
            send_line = "<Leader>vl",
            send_file = "<Leader>vf",
            exit = "<Leader>vq",
            clear = "<Leader>vx",
        },
        highlight = {
            italic = true,
        },
        ignore_blank_lines = true
    })
end

return {
    config = config
}

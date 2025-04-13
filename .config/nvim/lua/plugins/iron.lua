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
                        "--no-banner",
                        "-c",
                        "import IPython; ip = IPython.get_ipython(); ip.run_line_magic('load_ext', 'autoreload'); ip.run_line_magic('autoreload', '2')",
                        "--no-confirm-exit",
                        "--no-autoindent"
                    },
                    format = common.bracketed_paste_python,
                },
            },
            repl_open_cmd = view.right(80),
        },
        repl_filetype = function(bufnr, ft)
            return ft
        end,
        keymaps = {
            send_motion = "<Leader>rc",
            visual_send = "<Leader>rl",
            send_file = "<Leader>rf",
            send_line = "<Leader>rl",
            send_mark = "<Leader>rm",
            cr = "<Leader>r<cr>",
            interrupt = "<Leader>r<Leader>",
            exit = "<Leader>rq",
            clear = "<Leader>rx",
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



-- ipython -i --no-banner --no-tip -c "import IPython; ip = IPython.get_ipython(); ip.run_line_magic('load_ext', 'autoreload'); ip.run_line_magic('autoreload', '2')" --no-confirm-exit

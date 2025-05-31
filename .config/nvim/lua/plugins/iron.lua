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
                    command = { "python" },
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
            -- repl_open_cmd = view.right(80),
        },
        repl_filetype = function(bufnr, ft)
            return ft
        end,
        keymaps = {
            send_motion = "<Leader>ic",
            visual_send = "<Leader>il",
            send_line = "<Leader>il",
            send_file = "<Leader>if",
            -- send_mark = "<Leader>im",
            exit = "<Leader>iq",
            clear = "<Leader>ix",
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

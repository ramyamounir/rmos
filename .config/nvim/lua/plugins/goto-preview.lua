local function get_opts()
    -- define keymaps
    vim.keymap.set("n", "gpd", [[:lua require("goto-preview").goto_preview_definition()<CR>]],
        { silent = true, desc = "Preview definition" })
    vim.keymap.set("n", "gpD", [[:lua require('goto-preview').goto_preview_declaration()<CR>]],
        { silent = true, desc = "Preview declaration" })
    vim.keymap.set("n", "gpr", [[:lua require('goto-preview').goto_preview_references()<CR>]],
        { silent = true, desc = "Preview references" })
    vim.keymap.set("n", "gpq", [[:lua require("goto-preview").close_all_win()<CR>]],
        { silent = true, desc = "Quit preview windows" })

    local opts = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    }
    return opts
end

return {
    opts = get_opts
}

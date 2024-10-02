vim.cmd("filetype plugin indent on")

vim.g.tex_flavor = "xelatex"
vim.g.vimtex_view_method = "zathura"
vim.g.syntastic_tex_lacheck_quiet_messages = { regex = "\\Vpossible unwanted space at" }
vim.g.vimtex_quickfix_mode = 0

vim.g.vimtex_compiler_latexmk = {
    executable = "latexmk",
    options = {
        "-xelatex",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
    },
}

vim.api.nvim_create_augroup("WrapLineInTeXFile", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = "WrapLineInTeXFile",
    pattern = "tex",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.list = false

        local opts = { noremap = true, silent = true, buffer = true }

        vim.keymap.set("n", "j", "gj", opts)
        vim.keymap.set("n", "k", "gk", opts)
        vim.keymap.set("n", "0", "g0", opts)
        vim.keymap.set("n", "$", "g$", opts)

        vim.keymap.set("n", "<Up>", "gk", opts)
        vim.keymap.set("n", "<Down>", "gj", opts)
        vim.keymap.set("n", "<Home>", "g<Home>", opts)
        vim.keymap.set("n", "<End>", "g<End>", opts)

        vim.keymap.set("i", "<Up>", "<C-o>gk", opts)
        vim.keymap.set("i", "<Down>", "<C-o>gj", opts)
        vim.keymap.set("i", "<Home>", "<C-o>g<Home>", opts)
        vim.keymap.set("i", "<End>", "<C-o>g<End>", opts)
    end,
})

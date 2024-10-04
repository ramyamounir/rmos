-- Set up an autocommand group
local augroup = vim.api.nvim_create_augroup("CustomAutocommands", { clear = true })

-- TermOpen autocommands
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.cmd("startinsert")
    end,
})

-- set tabspace to 4 for yaml files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    command = "setlocal shiftwidth=4 tabstop=4 expandtab",
})

-- VimEnter autocommand
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
        if vim.fn.argc() > 0 then
            vim.cmd("wincmd p")
        end
    end,
})

-- -- Highlight yanked text for "timeout" duration
-- vim.api.nvim_create_autocmd('TextYankPost', {
--     callback = function()
--         vim.highlight.on_yank({ higroup = 'Visual', timeout = 500 })
--     end,
-- })

-- Set up an autocommand group
local augroup = vim.api.nvim_create_augroup("CustomAutocommands", { clear = true })

-- TermOpen autocommands
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        -- vim.cmd("startinsert")
    end,
})

-- set tabspace to 4 for yaml files
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "yaml",
--     command = "setlocal shiftwidth=4 tabstop=4 expandtab",
-- })

-- VimEnter autocommand
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
        if vim.fn.argc() > 0 then
            vim.cmd("wincmd p")
        end
    end,
})

-- This toggles auto format for the current buffer
vim.api.nvim_create_user_command("FormatToggle", function()
    if vim.b.disable_autoformat then
        vim.b.disable_autoformat = false
        vim.notify("Autoformat on save: enabled", vim.log.levels.INFO)
    else
        vim.b.disable_autoformat = true
        vim.notify("Autoformat on save: disabled", vim.log.levels.WARN)
    end
end, {
    desc = "Toggle autoformat-on-save for the current buffer",
})


-- This fixes ufo buffer folds by reattaching to buffer on read
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        vim.defer_fn(function()
            local ok, ufo = pcall(require, "ufo")
            if ok then
                ufo.detach(args.buf)
                ufo.attach(args.buf)
            end
        end, 0)
    end,
})

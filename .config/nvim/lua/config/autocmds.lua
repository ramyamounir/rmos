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

-- This is for iron to avoid marking the REPL as a buffer
vim.api.nvim_create_autocmd({ "BufWinEnter", "TermOpen" }, {
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
            return
        end

        local name = vim.api.nvim_buf_get_name(buf)
        if name:match("iron") or vim.bo[buf].filetype == "iron" then
            pcall(function()
                vim.bo[buf].buftype = "nofile"
                vim.bo[buf].bufhidden = "hide"
                vim.bo[buf].swapfile = false
            end)
        end
    end,
})


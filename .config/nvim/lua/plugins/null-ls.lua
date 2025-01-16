local function config()

    local null_ls_status_ok, null_ls = pcall(require, "null-ls")
    if not null_ls_status_ok then
        return
    end

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    local opts = {
        debug = false,
        sources = {
            formatting.isort,
            -- formatting.black.with({ extra_args = { "--fast", "--line-length=88"} }),
            -- diagnostics.flake8.with({ extra_args = { "--max-line-length=88" } }),
        },
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        -- vim.lsp.buf.format({async =false})
                        vim.lsp.buf.format({bufnr = bufnr})
                    end,
                })
            end
        end,
    }
    return opts
end

return {
    opts = config
}

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }

    local definition_lookup_cmd
    local reference_lookup_cmd
    local implementation_lookup_cmd

    local require_ok, _ = pcall(require, "telescope.builtin")
    if require_ok then
        definition_lookup_cmd = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>"
        reference_lookup_cmd = "<cmd>lua require('telescope.builtin').lsp_references()<CR>"
        implementation_lookup_cmd = "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>"
    else
        definition_lookup_cmd = "<cmd>lua vim.lsp.buf.definition()<CR>"
        reference_lookup_cmd = "<cmd>lua vim.lsp.buf.references()<CR>"
        implementation_lookup_cmd = "<cmd>lua vim.lsp.buf.implementation()<CR>"
    end

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", definition_lookup_cmd, opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", implementation_lookup_cmd, opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gR", reference_lookup_cmd, opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local on_attach = function(client, bufnr)
    -- disable ruff's hover in favour of Pyright's
    if client.name == 'ruff' then
        client.server_capabilities.hoverProvider = false
    end

    lsp_keymaps(bufnr)
end


local function diagnostics_setup()
    local config = {
        -- disable virtual text
        virtual_text = false,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '',
                [vim.diagnostic.severity.INFO] = '',
                [vim.diagnostic.severity.HINT] = '󱩕',
            }
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end


local function init()
    local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_status_ok then
        Capabilities = cmp_nvim_lsp.default_capabilities()
    end

    local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
    if not lspconfig_status_ok then return end

    for _, server in pairs(LspServers) do
        local filename = "plugins/lsp/" .. server
        local req_ok, configs = pcall(require, filename)

        if not req_ok then configs = {} end

        configs.on_attach = on_attach
        configs.capabilities = Capabilities

        lspconfig[server].setup(configs)
    end

    diagnostics_setup()
end

return {
    init = init
}

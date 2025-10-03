-- lua/plugins/lsp/init.lua

local function lsp_keymaps(bufnr)
    local has_telescope, tb = pcall(require, "telescope.builtin")
    local opts = { noremap = true, silent = true, buffer = bufnr }

    local gd = has_telescope and tb.lsp_definitions or vim.lsp.buf.definition
    local gi = has_telescope and tb.lsp_implementations or vim.lsp.buf.implementation
    local gR = has_telescope and tb.lsp_references or vim.lsp.buf.references

    vim.keymap.set("n", "gd", gd, opts)
    vim.keymap.set("n", "gi", gi, opts)
    vim.keymap.set("n", "gR", gR, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
        vim.lsp.buf.format()
    end, {})
end

local function on_attach(client, bufnr)
    -- prefer Pyright hover over Ruff
    if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
    end
    lsp_keymaps(bufnr)
end

local function diagnostics_setup()
    vim.diagnostic.config({
        virtual_text = false,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN]  = "",
                [vim.diagnostic.severity.INFO]  = "",
                [vim.diagnostic.severity.HINT]  = "󱩕",
            },
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
    })

    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local function init()
    -- Capabilities from cmp_nvim_lsp if present
    local Capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
        Capabilities = cmp_nvim_lsp.default_capabilities(Capabilities)
    end

    -- Global defaults merged into every server config
    vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = Capabilities,
    })

    -- Load per-server configs from your existing files: plugins/lsp/<server>.lua
    -- Assumes you already define LspServers = { "pyright", "lua_ls", ... } somewhere.
    for _, server in pairs(LspServers) do
        local ok, conf = pcall(require, "plugins.lsp." .. server)
        if ok then
            -- Merge/override per-server settings
            vim.lsp.config(server, conf)
        end
    end

    -- Enable and autostart the servers
    vim.lsp.enable(LspServers)

    diagnostics_setup()
end

return { init = init }

LspServers = {
	"bashls",
	"clangd",
	"cssls",
	"dockerls",
	"dotls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"markdown_oxide",
	"pyright",
	"ruff",
    "texlab",
	"typos_lsp",
	"yamlls",
}

local opts = {
    ensure_installed = LspServers,
    automatic_installation = true,
}

return {
	opts = opts,
}

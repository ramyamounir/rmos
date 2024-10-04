LspServers = {
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"dockerls",
	"dotls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"markdown_oxide",
	"pyright",
    "texlab",
	"typos_lsp",
	"yamlls",
}

local opts = {
    ui = {
        icons = {
            package_installed = "",
            package_pending = "󱑤",
            package_uninstalled = ""
        }
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4
}

return {
    opts = opts
}

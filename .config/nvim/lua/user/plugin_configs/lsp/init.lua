
local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.plugin_configs.lsp.mason"
require("user.plugin_configs.lsp.handlers").setup()
require "user.plugin_configs.lsp.null-ls"

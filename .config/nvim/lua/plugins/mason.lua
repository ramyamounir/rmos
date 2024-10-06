
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

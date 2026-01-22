return {
    config = function()
        require("direnv").setup({
            autoload_direnv = false,
            keybindings = {
                allow = false,
                deny = false,
                reload = false,
                edit = false,
            },
            notifications = {
                silent_autoload = true,
            },
        })
    end,
}

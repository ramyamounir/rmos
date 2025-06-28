return {
    config = function()
        require("direnv").setup({
            -- Keyboard mappings
            autoload_direnv = true,
            keybindings = {
                allow = "<Leader>ea",
                deny = "<Leader>ed",
                reload = "<Leader>er",
                edit = "<Leader>ee",
            },
        })
    end,
}

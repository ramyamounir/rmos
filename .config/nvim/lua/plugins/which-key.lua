local M = {
    event = "VeryLazy"
}

M.opts = {
    preset = "helix",
    notify = false,
    icons = {
        mappings = false,
        separator = "",
    },

}

M.keys = {
    {
        "<leader><leader>",
        function()
            require("which-key").show({ global = true })
        end,
        desc = "which-key: global keymaps"
    },
    {
        "<leader>?",
        function()
            require("which-key").show({ global = false })
        end,
        desc = "which-key: plugin keymaps"
    },
}

return M

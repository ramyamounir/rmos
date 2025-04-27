local dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.nvim',
}

return {
    dependencies = dependencies,

    ---@module 'render-markdown'
    ---@type 'render.md.UserConfig
    opts = {
        file_types = { "markdown", "codecompanion" },
    },
}

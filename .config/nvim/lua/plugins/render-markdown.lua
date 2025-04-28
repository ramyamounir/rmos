local dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.nvim',
}

return {
    dependencies = dependencies,
    opts = {
        file_types = { "markdown", "codecompanion" },
    },
}

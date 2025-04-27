require("config.options")  -- vim options
require("config.autocmds") -- vim auto commands
require("config.keymaps")  -- vim keymaps
require("config.utils")    -- vim utils

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


local plugins = {
    -- UI plugins
    PreparePackage("akinsho/bufferline.nvim", require("plugins.bufferline")),
    PreparePackage("lewis6991/gitsigns.nvim", require("plugins.gitsigns")),
    PreparePackage("lukas-reineke/indent-blankline.nvim", require("plugins.indent-blankline")),
    PreparePackage("nvim-lualine/lualine.nvim", require("plugins.lualine")),
    PreparePackage("nvim-neo-tree/neo-tree.nvim", require("plugins.neo-tree")),
    PreparePackage("folke/noice.nvim", require("plugins.noice")),
    PreparePackage("nvim-treesitter/nvim-treesitter", require("plugins.nvim-treesitter")),
    PreparePackage("rcarriga/nvim-notify", require("plugins.nvim-notify")),
    PreparePackage("nvim-telescope/telescope.nvim", require("plugins.telescope")),
    PreparePackage("nvim-tree/nvim-web-devicons", require("plugins.web-dev-icons")),
    PreparePackage("ellisonleao/gruvbox.nvim", require("plugins.gruvbox")),

    -- editor
    PreparePackage("iamcco/markdown-preview.nvim", require("plugins.markdown-preview")),
    PreparePackage("MeanderingProgrammer/render-markdown.nvim", require("plugins.render-markdown")),
    PreparePackage("ibhagwan/fzf-lua", require("plugins.fzf")),

    -- coding
    PreparePackage("lervag/vimtex", require("plugins.vimtex")),
    PreparePackage("hrsh7th/nvim-cmp", require("plugins.nvim-cmp")),
    PreparePackage("ramyamounir/codeium.nvim", require("plugins.codeium")),
    PreparePackage("hkupty/iron.nvim", require("plugins.iron")),
    PreparePackage("saadparwaiz1/cmp_luasnip"),
    PreparePackage("hrsh7th/cmp-buffer"),
    PreparePackage("hrsh7th/cmp-path"),
    PreparePackage("hrsh7th/cmp-nvim-lua"),
    PreparePackage("hrsh7th/cmp-nvim-lsp"),

    -- LSP
    PreparePackage("williamboman/mason.nvim", require("plugins.mason")),
    PreparePackage("williamboman/mason-lspconfig.nvim", require("plugins.mason-lspconfig")),
    PreparePackage("neovim/nvim-lspconfig", require("plugins.nvim-lspconfig")),
    PreparePackage("stevearc/conform.nvim", require("plugins.conform")),
    PreparePackage("mfussenegger/nvim-lint"),
    PreparePackage("rshkarin/mason-nvim-lint", require("plugins.mason-lintconfig")),
    PreparePackage("olimorris/codecompanion.nvim", require("plugins.codecompanion")),

    -- miscellaneous
    PreparePackage("machakann/vim-sandwich", require("plugins.sandwich")),
    PreparePackage("kevinhwang91/nvim-ufo", require("plugins.ufo")),
    PreparePackage("vim-test/vim-test", require("plugins.vim-test")),
    PreparePackage("rmagatti/goto-preview", require("plugins.goto-preview")),
    PreparePackage("machakann/vim-highlightedyank"),
    PreparePackage("vim-scripts/ReplaceWithRegister"),
    PreparePackage("tpope/vim-commentary"),
    PreparePackage("tpope/vim-repeat"),
}

return require("lazy").setup({
    spec = plugins,
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true }
})

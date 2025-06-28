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
    MergeTables("akinsho/bufferline.nvim", require("plugins.bufferline")),
    MergeTables("lewis6991/gitsigns.nvim", require("plugins.gitsigns")),
    MergeTables("lukas-reineke/indent-blankline.nvim", require("plugins.indent-blankline")),
    MergeTables("nvim-lualine/lualine.nvim", require("plugins.lualine")),
    MergeTables("nvim-neo-tree/neo-tree.nvim", require("plugins.neo-tree")),
    MergeTables("folke/noice.nvim", require("plugins.noice")),
    MergeTables("nvim-treesitter/nvim-treesitter", require("plugins.nvim-treesitter")),
    MergeTables("rcarriga/nvim-notify", require("plugins.nvim-notify")),
    MergeTables("nvim-telescope/telescope.nvim", require("plugins.telescope")),
    MergeTables("nvim-telescope/telescope-ui-select.nvim", require("plugins.telescope-ui-select")),
    MergeTables("nvim-tree/nvim-web-devicons", require("plugins.web-dev-icons")),
    MergeTables("ellisonleao/gruvbox.nvim", require("plugins.gruvbox")),

    -- editor
    MergeTables("iamcco/markdown-preview.nvim", require("plugins.markdown-preview")),
    MergeTables("MeanderingProgrammer/render-markdown.nvim", require("plugins.render-markdown")),
    MergeTables("ibhagwan/fzf-lua", require("plugins.fzf")),
    MergeTables("MeanderingProgrammer/harpoon-core.nvim", require("plugins.harpoon-core")),
    MergeTables("folke/flash.nvim", require("plugins.flash")),
    MergeTables("folke/twilight.nvim", require("plugins.twilight")),
    MergeTables("jbyuki/instant.nvim", require("plugins.instant")),
    MergeTables("Vigemus/iron.nvim", require("plugins.iron")),


    -- coding
    MergeTables("lervag/vimtex", require("plugins.vimtex")),
    MergeTables("hrsh7th/nvim-cmp", require("plugins.nvim-cmp")),
    MergeTables("saadparwaiz1/cmp_luasnip"),
    MergeTables("hrsh7th/cmp-buffer"),
    MergeTables("hrsh7th/cmp-path"),
    MergeTables("hrsh7th/cmp-nvim-lua"),
    MergeTables("hrsh7th/cmp-nvim-lsp"),
    MergeTables("mfussenegger/nvim-dap", require("plugins.nvim-dap")),

    -- LSP
    MergeTables("williamboman/mason.nvim", require("plugins.mason")),
    MergeTables("williamboman/mason-lspconfig.nvim", require("plugins.mason-lspconfig")),
    MergeTables("rshkarin/mason-nvim-lint", require("plugins.mason-lintconfig")),
    MergeTables("neovim/nvim-lspconfig", require("plugins.nvim-lspconfig")),
    MergeTables("stevearc/conform.nvim", require("plugins.conform")),
    MergeTables("mfussenegger/nvim-lint"),
    MergeTables("Kurama622/llm.nvim", require("plugins.llm")),

    -- miscellaneous
    MergeTables("machakann/vim-sandwich", require("plugins.sandwich")),
    MergeTables("kevinhwang91/nvim-ufo", require("plugins.ufo")),
    MergeTables("vim-test/vim-test", require("plugins.vim-test")),
    MergeTables("rmagatti/goto-preview", require("plugins.goto-preview")),
    MergeTables("machakann/vim-highlightedyank"),
    MergeTables("vim-scripts/ReplaceWithRegister"),
    MergeTables("tpope/vim-commentary"),
    MergeTables("tpope/vim-repeat"),
    MergeTables("folke/which-key.nvim", require("plugins.which-key")),
    MergeTables("NotAShelf/direnv.nvim", require("plugins.direnv")),
}

return require("lazy").setup({
    spec = plugins,
    checker = { enabled = true }
})

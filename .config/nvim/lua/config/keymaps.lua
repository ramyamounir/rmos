local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Delete default lsp implementation keymap to use GoReplace keymaps instead
vim.keymap.del('n', 'gri')

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate Tabs
keymap("n", "<Leader>j", ":q<CR>", opts)
keymap("n", "<Leader>k", ":tabnew<CR>", opts)
keymap("n", "H", ":tabprev<CR>", opts)
keymap("n", "L", ":tabnext<CR>", opts)

-- Buffer save and Yanking
keymap("n", "Y", "y$", opts)
keymap("n", "zz", ":wa<cr>", opts)
keymap("n", "ZZ", ":wqa<cr>", opts)

-- Start terminal and lazygit windows respecting direnv
vim.keymap.set({ "n", "i", "v", "t" }, "<C-Enter>", function()
    vim.fn.jobstart({ "terminal_root" }, {
        detach = true,
    })
end, { desc = "Open project terminal" })
vim.keymap.set({ "n", "i", "v", "t" }, "<C-'>", function()
    vim.fn.jobstart({ "lazygit_root" }, {
        detach = true,
    })
end, { desc = "Open lazygit" })

-- Terminal --
-- Better terminal navigation
keymap("t", "<Esc>", "<C-\\><C-N>", term_opts)
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("i", "<C-h>", "<Esc><C-w>h", term_opts)
keymap("i", "<C-j>", "<Esc><C-w>j", term_opts)
keymap("i", "<C-k>", "<Esc><C-w>k", term_opts)
keymap("i", "<C-l>", "<Esc><C-w>l", term_opts)


-- Telescope
vim.keymap.set("n", "<c-p>", function()
    require("plugins.telescope.wrappers").find_files()
end, { desc = "Find files in project root" })
vim.keymap.set("n", "<c-t>", function()
    require("plugins.telescope.wrappers").live_grep()
end, { desc = "Live grep in project root" })

-- Nvimtree
keymap("n", "<leader>e", ":Neotree toggle<cr>", opts)

-- UFO
keymap('n', 'zR', [[<Cmd>lua require('ufo').openAllFolds()<CR>]], opts)
keymap('n', 'zM', [[<Cmd>lua require('ufo').closeAllFolds()<CR>]], opts)

-- goto preview keymaps
keymap("n", "gpd", [[:lua require("goto-preview").goto_preview_definition()<CR>]], opts)
keymap("n", "gpD", [[:lua require('goto-preview').goto_preview_declaration()<CR>]], opts)
keymap("n", "gpr", [[:lua require('goto-preview').goto_preview_references()<CR>]], opts)
keymap("n", "<Esc>", [[:lua require("goto-preview").close_all_win()<CR>]], opts)

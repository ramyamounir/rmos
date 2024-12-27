local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)



-- Telescope
keymap("n", "<c-p>", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<c-S-p>", ":FzfLua files cwd=~ <CR>", { noremap = true, silent = true })
keymap("n", "<c-S-T>", ":FzfLua grep cwd=~ <CR>", { noremap = true, silent = true })

-- Nvimtree
keymap("n", "<leader>e", ":Neotree toggle<cr>", opts)




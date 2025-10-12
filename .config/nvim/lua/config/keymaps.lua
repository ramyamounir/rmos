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
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grn')

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", MergeTables(opts, { desc = "Navigate to left window" }))
keymap("n", "<C-j>", "<C-w>j", MergeTables(opts, { desc = "Navigate to window below" }))
keymap("n", "<C-k>", "<C-w>k", MergeTables(opts, { desc = "Navigate to window above" }))
keymap("n", "<C-l>", "<C-w>l", MergeTables(opts, { desc = "Navigate to right window" }))
keymap("i", "<C-h>", "<Esc><C-w>h", MergeTables(term_opts, { desc = "Navigate to left window from Insert Mode" }))
keymap("i", "<C-j>", "<Esc><C-w>j", MergeTables(term_opts, { desc = "Navigate to window below from Insert Mode" }))
keymap("i", "<C-k>", "<Esc><C-w>k", MergeTables(term_opts, { desc = "Navigate to window above from Insert Mode" }))
keymap("i", "<C-l>", "<Esc><C-w>l", MergeTables(term_opts, { desc = "Navigate to right window from Insert Mode" }))

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", MergeTables(opts, { desc = "Resize window up by 2" }))
keymap("n", "<C-Down>", ":resize -2<CR>", MergeTables(opts, { desc = "Resize window down by 2" }))
keymap("n", "<C-Left>", ":vertical resize -2<CR>", MergeTables(opts, { desc = "Resize window left by 2" }))
keymap("n", "<C-Right>", ":vertical resize +2<CR>", MergeTables(opts, { desc = "Resize window  right by 2" }))

-- Navigate Tabs
keymap("n", "<Leader>j", ":q<CR>", MergeTables(opts, { desc = "Close buffer" }))
keymap("n", "<Leader>k", ":tabnew<CR>", MergeTables(opts, { desc = "New tab" }))
keymap("n", "H", ":tabprev<CR>", MergeTables(opts, { desc = "Previous Tab" }))
keymap("n", "L", ":tabnext<CR>", MergeTables(opts, { desc = "Next Tab" }))

-- Better terminal navigation
keymap("t", "<Esc>", "<C-\\><C-N>", MergeTables(term_opts, { desc = "Escape to normal in Terminal mode" }))
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", MergeTables(term_opts, { desc = "Move to left buffer from Terminal mode" }))
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", MergeTables(term_opts, { desc = "Move to buffer below from Terminal mode" }))
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", MergeTables(term_opts, { desc = "Move to buffer above from Terminal mode" }))
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", MergeTables(term_opts, { desc = "Move to right buffer from Terminal mode" }))

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

-- Scripts
vim.keymap.set("n", "<leader>dj", function()
    require("scripts.json_dap_explorer").pick_and_debug()
end, { desc = "Pick JSON and debug (nvim-dap)" })

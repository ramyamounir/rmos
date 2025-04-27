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
keymap("n", "<c-p>", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<c-S-p>", ":FzfLua files cwd=~ <CR>", { noremap = true, silent = true })
keymap("n", "<c-S-T>", ":FzfLua grep cwd=~ <CR>", { noremap = true, silent = true })

-- Nvimtree
keymap("n", "<leader>e", ":Neotree toggle<cr>", opts)

-- UFO
keymap('n', 'zR', [[<Cmd>lua require('ufo').openAllFolds()<CR>]], opts)
keymap('n', 'zM', [[<Cmd>lua require('ufo').closeAllFolds()<CR>]], opts)

-- Iron
keymap('n', '<Leader>rr', [[<cmd>IronRepl<CR>]], { noremap = true, silent = true })
keymap('n', '<Leader>rR', [[<cmd>IronRestart<CR>]], { noremap = true, silent = true })

-- Go-replace-in in-house keymaps to circumvent an error from hell
keymap("n", "griw", "viw\"_dP", { noremap = true, silent = true })
keymap("n", "griW", "viW\"_dP", { noremap = true, silent = true })
keymap("n", "grip", "vip\"_dP", { noremap = true, silent = true })
keymap("n", "grit", "vit\"_dP", { noremap = true, silent = true })
keymap("n", "gri(", "vi(\"_dP", { noremap = true, silent = true })
keymap("n", "gri)", "vi(\"_dP", { noremap = true, silent = true })
keymap("n", "gri[", "vi[\"_dP", { noremap = true, silent = true })
keymap("n", "gri]", "vi]\"_dP", { noremap = true, silent = true })
keymap("n", "gri{", "vi{\"_dP", { noremap = true, silent = true })
keymap("n", "gri}", "vi}\"_dP", { noremap = true, silent = true })
keymap("n", "gri<", "vi<\"_dP", { noremap = true, silent = true })
keymap("n", "gri>", "vi>\"_dP", { noremap = true, silent = true })
keymap("n", "gri'", "vi'\"_dP", { noremap = true, silent = true })
keymap("n", "gri\"", "vi\"\"_dP", { noremap = true, silent = true })

-- goto preview keymaps
keymap("n", "gpd", [[:lua require("goto-preview").goto_preview_definition()<CR>]], { noremap = true, silent = true })
keymap("n", "gpD", [[:lua require('goto-preview').goto_preview_declaration()<CR>]], { noremap = true, silent = true })
keymap("n", "gpr", [[:lua require('goto-preview').goto_preview_references()<CR>]], { noremap = true, silent = true })
keymap("n", "<Esc>", [[:lua require("goto-preview").close_all_win()<CR>]], { noremap = true, silent = true })

-- codecompanion keymaps
keymap("n", "<leader>gg", [[:lua require("codecompanion").toggle()<CR>]], { noremap = true, silent = true })
keymap("n", "<leader>gn", [[:lua require("codecompanion").chat()<CR>]], { noremap = true, silent = true })
keymap("v", "<leader>ge", ":'<,'>CodeCompanion /explain<CR>",
    { noremap = true, silent = true, desc = "Explain selection" })
keymap("v", "<leader>gf", ":'<,'>CodeCompanion /fix<CR>",
    { noremap = true, silent = true, desc = "Fix code for selection" })
keymap("v", "<leader>gu", ":'<,'>CodeCompanion /tests<CR>",
    { noremap = true, silent = true, desc = "Create Unit Tests for selection" })
keymap("v", "<leader>gc", ":'<,'>CodeCompanion /commit<CR>",
    { noremap = true, silent = true, desc = "Create commit message for selection" })

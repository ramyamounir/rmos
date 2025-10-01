local function config()
    vim.g["test#strategy"] = "neovim" -- use Neovim terminal
    vim.g["test#python#runner"] = "pytest"
    -- vim.g["test#python#pytest#file_pattern"] = "\\v(test_.+|.+_test)\\.py$"
    vim.g["test#python#pytest#options"] = "--pdb"
    -- vim.g["test#neovim#term_position"] = "botright 10split"
    vim.g["test#neovim#term_position"] = "vert rightbelow 40vsplit"

    vim.g["test#python#pytest#executable"] = "direnv exec . pytest"
end

local keys = {
    { "<leader>tn", "<cmd>TestNearest<CR>", desc = "Test Nearest" },
    { "<leader>tc", "<cmd>TestClass<CR>",   desc = "Test Class" },
    { "<leader>tf", "<cmd>TestFile<CR>",    desc = "Test File" },
    { "<leader>ts", "<cmd>TestSuite<CR>",   desc = "Test Suite" },
    { "<leader>tl", "<cmd>TestLast<CR>",    desc = "Test Last" },
}

return {
    config = config,
    keys = keys,
}

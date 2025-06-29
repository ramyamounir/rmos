return {
    cmd = "GitLink",
    opts = {},
    keys = {
        { "<leader>lo",  "<cmd>GitLink remote=origin<cr>",          mode = { "n", "v" }, desc = "Yank git link for origin" },
        { "<leader>lu",  "<cmd>GitLink remote=upstream<cr>",        mode = { "n", "v" }, desc = "Yank git link for upstream" },
        { "<leader>lO",  "<cmd>GitLink! remote=origin<cr>",         mode = { "n", "v" }, desc = "Open git link for origin" },
        { "<leader>lU",  "<cmd>GitLink! remote=upstream<cr>",       mode = { "n", "v" }, desc = "Open git link for upstream" },
        { "<leader>lbo", "<cmd>GitLink blame remote=origin<cr>",    mode = { "n", "v" }, desc = "Yank git blame link for origin" },
        { "<leader>lbu", "<cmd>GitLink blame remote=upstream<cr>",  mode = { "n", "v" }, desc = "Yank git blame link for upstream" },
        { "<leader>lbO", "<cmd>GitLink! blame remote=origin<cr>",   mode = { "n", "v" }, desc = "Open git blame link for origin" },
        { "<leader>lbU", "<cmd>GitLink! blame remote=upstream<cr>", mode = { "n", "v" }, desc = "Open git blame link for upstream" },
    },
}

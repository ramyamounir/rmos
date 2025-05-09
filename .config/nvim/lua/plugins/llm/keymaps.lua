return {
    keys = {
        -- The keyboard mapping for the input window.
        ["Input:Submit"]      = { mode = { "n", "i" }, key = "<C-s>" },
        ["Input:Cancel"]      = { mode = { "n", "i" }, key = "<C-c>" },

        -- Session keymaps
        ["Session:Close"]     = { mode = { "n" }, key = "<leader>gq" },

        -- only works when "save_session = true"
        ["Input:HistoryNext"] = { mode = { "n", "i" }, key = "<C-j>" },
        ["Input:HistoryPrev"] = { mode = { "n", "i" }, key = "<C-k>" },

        -- Focus
        ["Focus:Input"]       = { mode = "n", key = { "i" } },
        ["Focus:Output"]      = { mode = { "n", "i" }, key = "<C-w>" },
    },
}

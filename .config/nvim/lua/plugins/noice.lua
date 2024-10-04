local function init()
    local function norm_unmapped(c)
        return vim.cmd({ cmd = "norm", args = { c }, bang = true })
    end

    vim.keymap.set("n", "n", function()
        pcall(norm_unmapped, "n")
    end)
    vim.keymap.set("n", "N", function()
        pcall(norm_unmapped, "N")
    end)

    vim.cmd([[nnoremap / :silent! /]])
    vim.cmd([[nnoremap ? :silent! /]])
end

local opts = {
    cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
            cmdline = {
                icon = ":",
            },
            search_down = {
                kind = "search",
                icon = " ",
            },
            search_up = {
                kind = "search",
                icon = " ",
            },
        },
        opts = {
            position = {
                row = "80%",
                col = "50%",
            },
        },
        size = {
            width = "50%",
            height = "auto",
        },
        skip = true,
    },
    presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    popupmenu = {
        enabled = true,
    },
    notify = {
        enabled = true,
    },
    messages = {
        enabled = false,
    }
}

return {
    event = "VeryLazy",
    opts = opts,
    init = init,
}

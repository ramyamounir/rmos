local dependencies = {
    "nvim-telescope/telescope.nvim",
}

local function get_opts()
    local harpoon = require("harpoon-core")

    local telescope = require("telescope")
    telescope.load_extension('harpoon-core')

    vim.keymap.set("n", "<leader>r-", function()
        telescope.extensions["harpoon-core"].marks()
        -- harpoon.toggle_quick_menu()
    end, { desc = "Open Harpoon-core Telescope picker with custom mappings" })

    vim.keymap.set("n", "<leader>rr", function()
        harpoon.add_file()
        vim.notify("File added to Harpoon list")
    end, { desc = "Harpoon: Add file" })

    vim.keymap.set("n", "<leader>rx", function()
        harpoon.rm_file()
        vim.notify("File removed from Harpoon list")
    end, { desc = "Remove current file from Harpoon List" })

    vim.keymap.set("n", "<Tab>", function()
        harpoon.nav_next()
    end, { desc = "Switch to next buffer in Harpoon List" })
    vim.keymap.set("n", "<S-Tab>", function()
        harpoon.nav_prev()
    end, { desc = "Switch to previous buffer in Harpoon List" })

    -- 🔢 Quick access to first 3 files
    vim.keymap.set("n", "<C-2>", function() harpoon.nav_file(1) end, { desc = "Harpoon: File 1" })
    vim.keymap.set("n", "<C-3>", function() harpoon.nav_file(2) end, { desc = "Harpoon: File 2" })
    vim.keymap.set("n", "<C-4>", function() harpoon.nav_file(3) end, { desc = "Harpoon: File 3" })
    vim.keymap.set("n", "<C-7>", function() harpoon.nav_file(4) end, { desc = "Harpoon: File 4" })
    vim.keymap.set("n", "<C-8>", function() harpoon.nav_file(5) end, { desc = "Harpoon: File 5" })
    vim.keymap.set("n", "<C-9>", function() harpoon.nav_file(6) end, { desc = "Harpoon: File 6" })

    local opts = {
        -- Make existing window active rather than creating a new window
        use_existing = true,
        -- Default action when opening a mark, defaults to current window
        -- Example: 'vs' will open in new vertical split, 'tabnew' will open in new tab
        default_action = nil,
        -- Set marks specific to each git branch inside git repository
        mark_branch = true,
        -- Use the previous cursor position of marked files when opened
        use_cursor = true,
        -- Settings for popup window
        menu = { width = 60, height = 10 },
        -- Controls confirmation when deleting mark in telescope
        delete_confirmation = false,
        -- Telescope picker bindings
        picker = {
            delete = '<C-x>',
            move_down = '<C-S-j>',
            move_up = '<C-S-k>',
        },
    }
    return opts
end

return {
    dependencies = dependencies,
    opts = get_opts,
}

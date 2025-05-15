local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    { "mike-jl/harpoonEx", opts = { reload_on_dir_change = true } },
}

local function get_opts()
    local harpoon = require("harpoon")
    harpoon:setup({})

    -- load harpoonEx extension
    local harpoonEx = require("harpoonEx")
    harpoon:extend(harpoonEx.extend())

    -- highlight current file
    local harpoon_ext = require("harpoon.extensions")
    harpoon:extend(harpoon_ext.builtins.highlight_current_file())

    local list = harpoon:list()

    vim.keymap.set("n", "<leader>r-", function()
        local telescope = require("telescope")
        telescope.extensions.harpoonEx.harpoonEx({
            attach_mappings = function(_, map)
                local actions = telescope.extensions.harpoonEx.actions
                map({ "i", "n" }, "<C-x>", actions.delete_mark)
                map({ "i", "n" }, "<C-S-k>", actions.move_mark_up)
                map({ "i", "n" }, "<C-S-j>", actions.move_mark_down)
                return true
            end,
        })
        return true
    end, { desc = "Open harpoon window" })

    vim.keymap.set("n", "<leader>rr", function()
        list:add()
        vim.notify("File added to Harpoon list")
    end, { desc = "Harpoon: Add file" })

    vim.keymap.set("n", "<leader>rx", function()
        harpoonEx.delete(harpoon:list())
        vim.notify("File removed from Harpoon list")
    end, { desc = "Add current filte to Harpoon List" })

    vim.keymap.set("n", "<S-Tab>", function()
        harpoonEx.next_harpoon(harpoon:list(), true)
    end, { desc = "Switch to previous buffer in Harpoon List" })
    vim.keymap.set("n", "<Tab>", function()
        harpoonEx.next_harpoon(harpoon:list(), false)
    end, { desc = "Switch to next buffer in Harpoon List" })

    vim.keymap.set("n", "<C-e>", function()
        harpoonEx.telescope_live_grep(harpoon:list())
    end, { desc = "Live grep harpoon files" })

    -- 🔢 Quick access to first 3 files
    vim.keymap.set("n", "<C-7>", function() list:select(1) end, { desc = "Harpoon: File 1" })
    vim.keymap.set("n", "<C-8>", function() list:select(2) end, { desc = "Harpoon: File 2" })
    vim.keymap.set("n", "<C-9>", function() list:select(3) end, { desc = "Harpoon: File 3" })
end

return {
    branch = "harpoon2",
    dependencies = dependencies,
    opts = get_opts,
}

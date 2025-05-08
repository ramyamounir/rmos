local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
}

local function get_opts()
    local harpoon = require("harpoon")

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<C-7>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-8>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-9>", function() harpoon:list():select(3) end)

    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
        { desc = "Open harpoon window" })

    local opts = {
        global_settings = {
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            markbranch = true,
            tabline = false,
            tabline_prefix = "  ",
            tabline_suffix = "  ",
        }
    }
    return opts
end

return {
    branch = "harpoon2",
    dependencies = dependencies,
    opts = get_opts,
}

local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    {
        "ramyamounir/telescope-git-file-history.nvim",
        branch = "master",
        dependencies = {
            "tpope/vim-fugitive"
        }
    }
}

local function init()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
        return
    end

    telescope.load_extension("media_files")
    telescope.load_extension("git_file_history")
end




local function get_opts()
    -- keymaps
    local wrappers = require("plugins.telescope.wrappers")
    vim.keymap.set("n", "<c-p>", function() wrappers.find_files() end, { desc = "Find files in project root" })
    vim.keymap.set("n", "<c-t>", function() wrappers.live_grep() end, { desc = "Live grep in project root" })

    local actions = require "telescope.actions"
    local gfh = require("telescope").extensions.git_file_history
    local gfh_actions = require("telescope").extensions.git_file_history.actions
    vim.keymap.set("n", "<leader>h-", function() gfh.git_file_history() end, { desc = "File history in git remote" })

    local opts = {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },
            mappings = {
                i = {
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-p>"] = actions.cycle_history_prev,

                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,

                    ["<esc>"] = actions.close,

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,

                    ["<CR>"] = actions.select_default,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,

                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    -- ["<C-l>"] = actions.complete_tag,
                    -- ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                },

                n = {
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                    ["j"] = actions.move_selection_next,
                    ["k"] = actions.move_selection_previous,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,

                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,

                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    ["?"] = actions.which_key,
                },
            },

            extensions = {
                media_files = {
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    find_cmd = "rg"
                },
                git_file_history = {
                    mappings = {
                        i = {
                            ["<C-g>"] = gfh_actions.open_in_browser,
                        },
                        n = {
                            ["<C-g>"] = gfh_actions.open_in_browser,
                        },
                    },

                    -- The command to use for opening the browser (nil or string)
                    -- If nil, it will check if xdg-open, open, start, wslview are available, in that order.
                    browser_command = "xdg-open",
                },
            },
        }
    }
    return opts
end

return {
    dependencies = dependencies,
    init = init,
    opts = get_opts
}

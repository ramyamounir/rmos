local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim",
}

local function traverse_to_the_end(state)
    local status_ok, renderer = pcall(require, "neo-tree.ui.renderer")
    if not status_ok then
        return
    end

    local tree = state.tree
    local node = tree:get_node()
    local siblings = tree:get_nodes(node:get_parent_id())
    renderer.focus_node(state, siblings[#siblings]:get_id())
end

local function traverse_to_the_beginning(state)
    local status_ok, renderer = pcall(require, "neo-tree.ui.renderer")
    if not status_ok then
        return
    end

    local tree = state.tree
    local node = tree:get_node()
    local siblings = tree:get_nodes(node:get_parent_id())
    renderer.focus_node(state, siblings[1]:get_id())
end


local function traverse_in_directory(state)
    local status_ok, filesystem = pcall(require, "neo-tree.sources.filesystem")
    if not status_ok then
        return
    end

    local node = state.tree:get_node()
    if node.type == "directory" then
        filesystem.navigate(state, node.id)
    else
        local parent_node = state.tree:get_node():get_parent_id()
        filesystem.navigate(state, parent_node)
    end
end

local opts = {
    enable_diagnostics = false,
    default_component_configs = {
        indent = {
            last_indent_marker = "╰╴",
        },
        name = {
            use_git_status_colors = false,
            highlight = "NeoTreeFileName"
        },
        git_status = {
            symbols = {
                -- Change type
                added = "",
                modified = "󰴒",
                deleted = "󰛌",
                renamed = "󰙖",
                untracked = "󰽤",
                ignored = "󰈉",
                unstaged = "",
                staged = "󰗠",
                conflict = "",
            },
        },
        modified = {
            symbol = "",
            highlight = "NeoTreeModifier"
        },
        icon = {
            default = "",
            highlight = "NeoTreeFileIcon"
        }
    },
    window = {
        width = 35,
        mappings = {
            ["D"] = "delete",
            ["I"] = "toggle_hidden",
            ["<leader>r"] = "refresh",
            ["G"] = traverse_to_the_end,
            ["gg"] = traverse_to_the_beginning,
            ["l"] = traverse_in_directory,
            ["h"] = "navigate_up",
            ["/"] = "noop",
            ["E"] = "expand_all_nodes",
            ["C"] = "close_all_nodes"
        },
    },
    filesystem = {
        follow_current_file = {
            enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        filtered_items = {
            visible = true,
            hide_dotfiles = true,
            hide_gitignored = true,
            show_hidden_count = false,
        },
    },
    git_status = {
        window = {
            mappings = {}
        }
    }
}

return {
    dependencies = dependencies,
    opts = opts,
    keys = {
        {"<leader>e", "<cmd>Neotree toggle<cr>", "n", desc="NeoTree"}
    }
}

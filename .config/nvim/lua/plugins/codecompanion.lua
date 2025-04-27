local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
}

local opts = {
    strategies = {
        chat = {
            roles = {
                ---The header name for the LLM's messages
                ---@type string|fun(adapter: CodeCompanion.Adapter): string
                llm = function(adapter)
                    return "CodeCompanion (" .. adapter.formatted_name .. ")"
                end,

                ---The header name for your messages
                ---@type string
                user = "Ramy",
            },
            adapter = "ollama",
            keymaps = {
                close = {
                    modes = { n = "<leader>gq" },
                    index = 4,
                    callback = "keymaps.close",
                    description = "Close Chat",
                },
                clear = {
                    modes = { n = "<leader>gx" },
                    index = 6,
                    callback = "keymaps.clear",
                    description = "Clear Chat",
                },
                next_chat = {
                    modes = { n = "]]" },
                    index = 11,
                    callback = "keymaps.next_chat",
                    description = "Next Chat",
                },
                previous_chat = {
                    modes = { n = "[[" },
                    index = 12,
                    callback = "keymaps.previous_chat",
                    description = "Previous Chat",
                },
                next_header = {
                    modes = { n = "}" },
                    index = 13,
                    callback = "keymaps.next_header",
                    description = "Next Header",
                },
                previous_header = {
                    modes = { n = "{" },
                    index = 14,
                    callback = "keymaps.previous_header",
                    description = "Previous Header",
                },
            },
        },
        inline = {
            adapter = "ollama",
        },
    },
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                env = {
                    model = "llama3.2:3b",
                    url = "https://ollama.sujal.tv",
                    api_key = "OLLAMA_API_KEY",
                },
                headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] = "Bearer ${api_key}",
                },
                parameters = {
                    sync = true,
                },
            })
        end,
    },
    display = {
        chat = {
            auto_scroll = false,
            show_token_count = false,
        },
    },
}


return {
    opts = opts,
    dependencies = dependencies,
}

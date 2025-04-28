local dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
}


local opts = {
    strategies = {
        chat = {
            roles = {
                llm = function(adapter)
                    return adapter.schema.model.default
                end,
                user = "Ramy",
            },
            adapter = "ollama",
            keymaps = {
                send = {
                    modes = { n = '<Enter>' },
                    callback = "keymaps.send",
                    description = "Send Message"
                },
                close = {
                    modes = { n = "<leader>gq" },
                    callback = "keymaps.close",
                    description = "Close Chat",
                },
                clear = {
                    modes = { n = "<leader>gx" },
                    callback = "keymaps.clear",
                    description = "Clear Chat",
                },
                next_chat = {
                    modes = { n = "]]" },
                    callback = "keymaps.next_chat",
                    description = "Next Chat",
                },
                previous_chat = {
                    modes = { n = "[[" },
                    callback = "keymaps.previous_chat",
                    description = "Previous Chat",
                },
                next_header = {
                    modes = { n = "}" },
                    callback = "keymaps.next_header",
                    description = "Next Header",
                },
                previous_header = {
                    modes = { n = "{" },
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
        opts = {
            show_defaults = false,
        },
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "LLM",
                schema = {
                    model = {
                        -- default = "codellama:13b",
                        default = "granite3.3:8b",
                    },
                    num_ctx = {
                        -- default = 15000,
                        default = 130000,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
                env = {
                    url = "https://ollama.lab.ramymounir.com",
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
    prompt_library = {
        ['Send Code'] = require("plugins.codecompanion.prompts").send_code,
        ['Unit Tests'] = { strategy = "chat" },
    },
}


return {
    opts = opts,
    dependencies = dependencies,
}

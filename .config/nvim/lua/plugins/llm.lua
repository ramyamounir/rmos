local dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
}

local function config()
    local tools = require("llm.tools")

    require("llm").setup({
        url = "https://ollama.lab.ramymounir.com/api/chat",
        model = "llama3.1:8b",
        api_type = "ollama",
        fetch_key = function()
            return vim.env.OLLAMA_API_KEY
        end,
        temperature = 0.3,
        top_p = 0.7,
        prompt = "You are a helpful assistant.",

        prefix = {
            user = { text = "😃 ", hl = "Title" },
            assistant = { text = "  ", hl = "Added" },
        },

        history_path = "/tmp/llm-history",
        save_session = true,
        max_history = 15,
        max_history_name_length = 20,

        chat_ui_opts = {
            border = {
                style = "rounded",
                text = { top = " Chat - LLM " },
            },
            enter = true,
            focusable = true,
            size = {
                width = 0.6,
                height = 0.6,
            },
        },
        app_handler = {
            Completion = {
                handler = tools.completion_handler,
                opts = {
                    fetch_key = function()
                        return vim.env.OLLAMA_API_KEY
                    end,
                    url = "https://ollama.lab.ramymounir.com/api/generate",
                    model = "llama3.1:8b",
                    api_type = "ollama",
                    n_completions = 3,
                    context_window = 512,
                    max_tokens = 256,
                    filetypes = { sh = false },
                    default_filetype_enabled = true,
                    auto_trigger = true,
                    only_trigger_by_keywords = true,
                    style = "nvim-cmp",
                    timeout = 10,
                    throttle = 1000,
                    debounce = 400,
                    keymap = {
                        toggle = {
                            mode = "n",
                            keys = "<leader>cp",
                        },
                    },
                },
            },
            CodeExplain = {
                handler = tools.side_by_side_handler,
                prompt = "Explain the following code, please only return the explanation, and answer in English",
                opts = {
                    enter_flexible_window = true,
                },
            },
            TestCode = {
                handler = tools.side_by_side_handler,
                prompt = [[ Write some test cases for the following code, only return the test cases.
                        Give the code content directly, do not use code blocks or other tags to wrap it. ]],
                opts = {
                    right = {
                        title = " Test Cases ",
                    },
                },
            },
            Ask = {
                handler = tools.disposable_ask_handler,
                opts = {
                    position = {
                        row = 2,
                        col = 0,
                    },
                    title = " Ask ",
                    inline_assistant = true,
                    language = "English",

                    -- display diff
                    display = {
                        mapping = {
                            mode = "n",
                            keys = { "d" },
                        },
                        action = nil,
                    },
                    -- accept diff
                    accept = {
                        mapping = {
                            mode = "n",
                            keys = { "Y", "y" },
                        },
                        action = nil,
                    },
                    -- reject diff
                    reject = {
                        mapping = {
                            mode = "n",
                            keys = { "N", "n" },
                        },
                        action = nil,
                    },
                    -- close diff
                    close = {
                        mapping = {
                            mode = "n",
                            keys = { "<esc>" },
                        },
                        action = nil,
                    },
                },
            },
        },
    })
end

local keys = {
    -- Chat UI controls
    { "<leader>gg", mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Toggle LLM Chat" },
    { "<leader>gx", mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Clear Chat (Toggle Hack)" },
    { "<leader>gq", mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Close Chat (Toggle Hack)" },
    { "]]",         mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Next Chat (stub)" },
    { "[[",         mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Prev Chat (stub)" },
    { "}",          mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Next Header (stub)" },
    { "{",          mode = "n", "<cmd>LLMSessionToggle<cr>",         desc = "Prev Header (stub)" },

    -- Prompt-based tools
    { "<leader>gl", mode = "x", "<cmd>LLMAppHandler SendCode<cr>",   desc = "Send Code to AI" },
    { "<leader>gu", mode = "x", "<cmd>LLMAppHandler UnitTests<cr>",  desc = "Generate Unit Tests" },

    { "<leader>ge", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>" },
    { "<leader>gt", mode = "x", "<cmd>LLMAppHandler TestCode<cr>" },
}


return {
    dependencies = dependencies,
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = config,
    keys = keys,
}

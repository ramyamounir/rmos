local dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
}


local function config()
    local apps = require("plugins.llm.app")
    local keymaps = require("plugins.llm.keymaps")
    local opts = {
        url = "https://ollama.lab.ramymounir.com/api/chat",
        model = "llama3.1:8b",
        api_type = "ollama",
        fetch_key = function()
            return vim.env.OLLAMA_API_KEY
        end,
        temperature = 0.3,
        top_p = 0.7,
        prompt = "You are a helpful assistant.",
        keys = keymaps.keys,

        prefix = {
            user = { text = "😃 ", hl = "Title" },
            assistant = { text = "  ", hl = "Added" },
        },

        history_path = "/tmp/llm-history",
        save_session = true,
        max_history = 15,
        max_history_name_length = 10,

        spinner = {
            text = { "󰧞󰧞", "󰧞󰧞", "󰧞󰧞", "󰧞󰧞" },
            hl = "Title",
        },
        chat_ui_opts = {
            border = {
                style = "rounded",
                text = { top = " Chat - LLM " },
            },
            enter = true,
            focusable = true,
            size = {
                width = "80%",
                height = "80%",
            },
            input = {
                float = {
                    size = {
                        height = "20%",
                    }
                }
            }
        },
        app_handler = apps.app_handler

    }
    require("llm").setup(opts)
end

local keys = {
    -- Chat UI controls
    { "<leader>gg", mode = "n", "<cmd>LLMSessionToggle<cr>",                                         desc = "Toggle LLM Chat" },
    { "<leader>gx", mode = "n", function() require("plugins.llm.commands").clear_current_chat() end, desc = "Clear Current LLM Chat" },
    { "<leader>gX", mode = "n", function() require("plugins.llm.commands").clear_chat_history() end, desc = "Clear all chats" },

    -- Prompt-based tools
    { "<leader>ge", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>",                                desc = "Explain a chunk of code" },
    { "<leader>gt", mode = "x", "<cmd>LLMAppHandler TestCode<cr>",                                   desc = "Create unit tests" },
    { "<leader>gm", mode = "n", "<cmd>LLMAppHandler CommitMsg<cr>",                                  desc = "Create Commit Message" },
    { "<leader>gd", mode = "v", "<cmd>LLMAppHandler DocString<cr>",                                  desc = "Create DocString" },
    { "<leader>gl", mode = "v", "<cmd>LLMAppHandler AttachToChat<cr>",                               desc = "Attach code block to chat" },
    { "<leader>go", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>",                               desc = "Optimize code block" },
}


return {
    dependencies = dependencies,
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = config,
    keys = keys,
}

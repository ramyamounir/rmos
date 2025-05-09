local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")

return {
    app_handler = {
        TestCode = {
            handler = tools.side_by_side_handler,
            prompt = prompts.TestCode,
            opts = {
                right = {
                    title = " Test Cases ",
                },
            },
        },
        DocString = {
            prompt = prompts.DocString,
            handler = tools.action_handler,
            opts = {
                only_display_diff = true,
                templates = {
                    lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".]],
                    python = [[- For the python language, you should use the google style.]],
                },
            },
        },
        CodeExplain = {
            handler = tools.flexi_handler,
            prompt = prompts.CodeExplain,
            opts = {
                enter_flexible_window = true,
            },
        },
        CommitMsg = {
            handler = tools.flexi_handler,
            prompt = prompts.CommitMsg,
            opts = {
                enter_flexible_window = true,
                apply_visual_selection = false,
                win_opts = {
                    relative = "editor",
                    position = "50%",
                    zindex = 100,
                },
                accept = {
                    mapping = {
                        mode = "n",
                        keys = "<cr>",
                    },
                    action = function()
                        local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)
                        local text = table.concat(contents, "\n")

                        -- Yank to system clipboard ("+")
                        vim.fn.setreg('+', text) -- optional, for clipboard

                        -- Notify the user (optional)
                        vim.notify("Commit message yanked to registers", vim.log.levels.INFO)
                    end,
                },
            },
        },
        AttachToChat = {
            handler = tools.attach_to_chat_handler,
            opts = {
                is_codeblock = true,
                inline_assistant = false,
                language = "English",
            },
        },
        OptimizeCode = {
            handler = tools.side_by_side_handler,
            opts = {
                left = {
                    focusable = false,
                },
            },
        },
        Completion = {
            handler = tools.completion_handler,
            opts = {
                fetch_key = function()
                    return vim.env.OLLAMA_API_KEY
                end,
                url = "https://ollama.lab.ramymounir.com/v1/completions",
                model = "qwen2.5-coder:1.5b",
                api_type = "ollama",
                n_completions = 3,
                context_window = 512,
                max_tokens = 256,
                filetypes = { sh = false },
                default_filetype_enabled = true,
                auto_trigger = false,
                -- only_trigger_by_keywords = true,
                style = "nvim-cmp",
                timeout = 10,
                throttle = 1000,
                debounce = 400,
                keymap = {
                    toggle = {
                        mode = "n",
                        keys = "<leader>gc",
                    },
                },
            },
        },
    },
}

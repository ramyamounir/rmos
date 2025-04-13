
local dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick", -- file picker
    {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- recommended settings
            default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = {
                  insert_mode = true,
                },
                -- required for Windows users
                use_absolute_path = true,
            },
        },
    },
    {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
    }
}

-- https://github.com/yetone/avante.nvim
local opts = {
    auto_suggestions_provider = "ollama",
    provider = "ollama",
    windows = {
        width = 40
    },
    mappings = {
        submit = {
            insert = "<CR>"
        }
    },
    behaviour = {
        auto_suggestions = false
    },
    vendors = {
        ollama = {
            __inherited_from = "openai",
            api_key_name = "LLM_API_KEY",
            endpoint = "https://llm.lab.ramymounir.com/api",
            -- endpoint = "https://llm.sujal.tv/api",
            model = "gpt-4o",
            temperature = 0.8,
            disable_tools = true,
        }
    }
}

local function is_enabled()
    local version = vim.version()
    -- Check if version is at least 0.10.0
    if version.major == 0 and version.minor >= 10 then
        return true
    end
    return false
end

return {
    enabled = is_enabled(),
    event = "VeryLazy",
    lazy = false,
    version = "*",
    opts = opts,
    build = "make",
    dependencies = dependencies
}

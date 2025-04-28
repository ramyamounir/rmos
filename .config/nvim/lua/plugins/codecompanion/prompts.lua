local M = {}

M.send_code = {
    name = "Send Code",
    strategy = "chat",
    description = "Send selected code to chat buffer",
    type = nil,
    opts = {
        index = 1,
        modes = { "v" },
        short_name = "send",
        auto_submit = false,
        user_prompt = false,
        stop_context_insertion = true,
    },
    prompts = {
        v = {
            {
                role = "user",
                content = function(context)
                    local text = require("codecompanion.helpers.actions").get_code(
                        context.start_line,
                        context.end_line
                    )
                    return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
                end,
                opts = {
                    contains_code = true,
                },
            },
        },
    },
}

return M

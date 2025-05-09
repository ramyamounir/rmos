-- ~/.config/nvim/lua/plugins/llm/commands.lua

local M = {}

function M.clear_current_chat()
    local state = require("llm.state")
    local F = require("llm.common.api")

    -- Determine which session is currently active
    local filename = state.session.filename or "current"

    -- Reset the session messages
    state.session[filename] = {}

    -- Clear the output buffer
    if state.llm.bufnr and vim.api.nvim_buf_is_valid(state.llm.bufnr) then
        vim.api.nvim_buf_set_lines(state.llm.bufnr, 0, -1, false, {})
    end

    -- Clear the input buffer (if it exists)
    if state.input.popup and state.input.popup.bufnr then
        vim.api.nvim_buf_set_lines(state.input.popup.bufnr, 0, -1, false, {})
    end

    -- Update prompt (if needed)
    F.UpdatePrompt(filename)
end

function M.clear_chat_history()
    local path = "/tmp/llm-history/"
    local files = vim.fn.glob(path .. "*.json", true, true)

    -- Delete all chat files
    for _, file in ipairs(files) do
        local ok, err = os.remove(file)
        if ok then
            print("✅ Deleted:", file)
        else
            print("❌ Failed to delete:", file, err)
        end
    end

    -- Clear session table
    local state = require("llm.state")
    for key, _ in pairs(state.session) do
        if key ~= "filename" then
            state.session[key] = nil
        end
    end
end

return M

local M = {}

function M.pick_chat()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local previewers = require("telescope.previewers")
    local codecompanion = require("codecompanion")

    local loaded_chats = codecompanion.buf_get_chat()
    if not loaded_chats or vim.tbl_isempty(loaded_chats) then
        vim.notify("[CodeCompanion] No open chats available.", vim.log.levels.WARN)
        return
    end

    -- build entries directly
    local open_chats = {}
    for _, data in ipairs(loaded_chats) do
        table.insert(open_chats, {
            name = data.name,
            description = data.description,
            bufnr = data.chat.bufnr,
            callback = function()
                codecompanion.close_last_chat()
                data.chat.ui:open()
            end,
        })
    end

    pickers.new({}, {
        prompt_title = "Select a chat",
        finder = finders.new_table({
            results = open_chats,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = (entry.name or "<no name>"),
                    ordinal = entry.name or "<no name>",
                    bufnr = entry.bufnr,
                }
            end,
        }),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, _status)
                if entry.value and entry.value.bufnr then
                    local bufnr = entry.value.bufnr
                    if vim.api.nvim_buf_is_valid(bufnr) then
                        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                        vim.api.nvim_set_option_value('filetype', 'markdown', { buf = self.state.bufnr })
                    else
                        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Invalid buffer" })
                    end
                else
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "No buffer" })
                end
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, _)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                if selection then
                    selection.value.callback()
                end
            end)
            return true
        end,
    }):find()
end

return M

local builtin = require("telescope.builtin")

local function project_cwd()
    return os.getenv("PROJECT_ROOT") or vim.fn.getcwd()
end

local M = {}

M.find_files = function()
    builtin.find_files({ cwd = project_cwd() })
end

M.live_grep = function()
    builtin.live_grep({ cwd = project_cwd() })
end

return M

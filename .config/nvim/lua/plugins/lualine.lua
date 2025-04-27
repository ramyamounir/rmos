local dependencies = { 'nvim-tree/nvim-web-devicons' }

-- Spinner data
local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_symbols_len = #spinner_symbols

-- Spinner state
local spinner = {
    processing = false,
    spinner_index = 1,
}

-- Setup autocommands to listen to CodeCompanion events
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true })
vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function()
        spinner.processing = true
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function()
        spinner.processing = false
    end,
})

-- Component function for lualine
local function CodeCompanionSpinner()
    if spinner.processing then
        spinner.spinner_index = (spinner.spinner_index % spinner_symbols_len) + 1
        return spinner_symbols[spinner.spinner_index] .. " "
    end
    return ""
end

-- Your normal lualine config
local opts = {
    options = {
        component_separators = { left = '•', right = '•' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {
            CodeCompanionSpinner,
            {
                'diagnostics',
                symbols = { error = '  ', warn = ' ', info = '  ', hint = '󰌵 ' },
            }
        },
        lualine_y = { 'encoding', 'fileformat', 'filetype' },
        lualine_z = { 'progress', 'location' }
    }
}

return {
    dependencies = dependencies,
    opts = opts,
}

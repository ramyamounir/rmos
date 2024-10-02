local status_ok, gitsigns = pcall(require, "lualine")
if not status_ok then
  return
end

local opts = {
    options = {
        component_separators = { left = '•', right = '•'},
        section_separators = { left = '', right = ''},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'diagnostics' },
        lualine_y = {'encoding', 'fileformat', 'filetype'},
        lualine_z = {'progress', 'location'}
    }
}

gitsigns.setup(opts)


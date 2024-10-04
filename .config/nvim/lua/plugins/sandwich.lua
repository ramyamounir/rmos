local function config()
    vim.api.nvim_command('runtime macros/sandwich/keymap/surround.vim')
end

return {
    config = config
}

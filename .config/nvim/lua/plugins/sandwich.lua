local function init()
    vim.g.operator_sandwich_no_default_key_mappings = 1
end

local function config()
    vim.api.nvim_command('runtime macros/sandwich/keymap/surround.vim')
end

return {
    init = init,
    config = config
}

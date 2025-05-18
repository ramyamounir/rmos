local function get_opts()
    vim.cmd([[colorscheme gruvbox]])
end


return {
    priority = 1000,
    config = true,
    opts = get_opts,
}

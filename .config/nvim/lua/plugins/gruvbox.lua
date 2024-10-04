
local function config()
    vim.o.background = "dark" -- or "light" for light mode
    vim.cmd([[colorscheme gruvbox]])
end


return {
    priority = 1000 ,
    config = config,
}

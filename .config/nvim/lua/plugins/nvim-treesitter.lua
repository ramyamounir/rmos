local opts = {
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "vim",
        "yaml",
    },
    sync_install = false,
    highlight = {
        enable = true,
        disable = {},
        -- additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { "yaml" }, -- fine to disable yaml indenting
    },
}

return {
    lazy = false,
    opts = opts,
}







-- local opts = {
--   ensure_installed = "all",
--   sync_install = false,
--   ignore_install = { "" }, -- List of parsers to ignore installing
--   highlight = {
--     enable = true, -- false will disable the whole extension
--     disable = { "" }, -- list of language that will be disabled
--     additional_vim_regex_highlighting = true,

--   },
--   indent = { enable = true, disable = { "yaml" } },
-- }

-- return {
--     lazy=false,
--     opts = opts,
-- }

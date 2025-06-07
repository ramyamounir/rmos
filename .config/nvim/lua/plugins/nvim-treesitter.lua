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
        "dap_repl",
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
    branch = 'master',
    build = ":TSUpdate",
}

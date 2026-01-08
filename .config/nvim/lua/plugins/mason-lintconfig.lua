local LintingFormattingServers = {
    "docformatter",
    "fixjson",
    "latexindent",
    "prettier",
    "shfmt",
    "tex-fmt",
    "xmlformatter",
    "yamlfix",
    "debugpy",
}

local opts = {
    -- ensure_installed = LintingFormattingServers,
    automatic_installation = {
        exclude = { "inko", "clj-kondo", "janet", "ruby" },
    },
}

return {
    opts = opts,
}

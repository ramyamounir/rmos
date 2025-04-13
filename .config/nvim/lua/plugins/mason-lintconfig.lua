local LintingFormattingServers = {
    "docformatter",
    "fixjson",
    "latexindent",
    "prettier",
    "shfmt",
    "tex-fmt",
    "xmlformatter",
    "yamlfix",
}

local opts = {
    ensure_installed = LintingFormattingServers,
    automatic_installation = true,
}

return {
	opts = opts,
}

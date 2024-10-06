local LintingFormattingServers = {
    "flake8",
    "black",
    "isort"
}

local opts = {
    ensure_installed = LintingFormattingServers,
    automatic_installation = true,
}

return {
	opts = opts,
}

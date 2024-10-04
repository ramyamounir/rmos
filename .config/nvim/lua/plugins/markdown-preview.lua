local commands = {
    "MarkdownPreviewToggle",
    "MarkdownPreview",
    "MarkdownPreviewStop",
}

local function init()
    vim.g.mkdp_filetypes = { "markdown" }
end

return {
    cmd = commands,
    build = "cd app && npx --yes yarn install",
    init = init,
    ft = { "markdown" },
}

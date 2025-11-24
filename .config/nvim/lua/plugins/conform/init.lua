local function in_git_repo()
    local git_dir = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
    return git_dir == "true"
end

local function ruff_format_custom(bufnr)
    vim.cmd("write")

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local relpath = vim.fn.fnamemodify(filename, ":.")

    if not in_git_repo() then
        return { "ruff_fix", "ruff_format", "ruff_organize_imports" }
    end

    -- Get hunks from git diff
    local diff = vim.fn.systemlist("git diff -U1 --no-color -- " .. relpath)
    local ranges = {}

    for _, line in ipairs(diff) do
        local start, count = line:match("^@@ %-%d+,%d+ %+(%d+),?(%d*) @@")
        if start then
            start = tonumber(start)
            count = tonumber(count ~= "" and count or 1)
            table.insert(ranges, { start = start, stop = start + count })
        end
    end

    -- Sort bottom-to-top
    table.sort(ranges, function(a, b)
        return a.start > b.start
    end)

    -- Apply ruff per range
    for _, range in ipairs(ranges) do
        local ruff_cmd = {
            "ruff", "format",
            "--range", string.format("%d-%d", range.start, range.stop),
            "--silent",
            filename,
        }

        local shell_cmd = table.concat(ruff_cmd, " ")
        vim.fn.system(shell_cmd)
    end

    vim.cmd("edit!")
    return { "ruff_organize_imports" }
end


local opts = {
    -- https://github.com/stevearc/conform.nvim
    formatters_by_ft = {
        bash = { "shfmt" },
        bib = { "shfmt" },
        css = { "cssprettier" },
        html = { "htmlprettier" },
        javascript = { "jsprettier" },
        -- python = ruff_format_custom,
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        json = { "fixjson" },
        tex = { "latex", "latexindent", stop_after_first = false },
        sh = { "shshfmt" },
        yaml = { "yamlfix" },
        zsh = { "shfmt" }
    },
    formatters = {
        bibtidy = {
            command = "bibtex-tidy",
            args = { "--space=4", "--align=15", "--blank-lines=1", "--merge=overwrite", "--drop-all-caps=1", "--remove-empty-fields=1", "--months=1", "$FILENAME" },
            stdin = false
        },
        cssprettier = {
            command = "prettier",
            args = { "-w", "--parser=css", "--tab-width=4", "--use-tabs=false", "--single-quote=false", "$FILENAME" },
            stdin = false
        },
        fixjson = {
            command = "fixjson",
            args = { "-w", "-i=4", "$FILENAME" },
            stdin = false
        },
        htmlprettier = {
            command = "prettier",
            args = { "-w", "--parser=html", "--tab-width=4", "--use-tabs=false", "--single-quote=false", "$FILENAME" },
            stdin = false
        },
        jsprettier = {
            command = "prettier",
            args = { "-w", "--tab-width=4", "--use-tabs=false", "--single-quote=false", "$FILENAME" },
            stdin = false
        },
        latex = {
            command = "tex-fmt",
            args = { "-t=4", "$FILENAME" },
            stdin = false
        },
        latexindent = {
            command = "latexindent",
            args = { "-w", "-g=/dev/null", "--local=" .. vim.env.XDG_CONFIG_HOME .. "/nvim/lua/plugins/formatters/latexindent.yaml", "$FILENAME" },
            stdin = false
        },
        ruff_organize_imports = {
            command = "ruff",
            args = { "check", "--fix", "--select", "I", "--silent", "$FILENAME" },
            stdin = false
        },
        shfmt = {
            args = { "-i=4", "-ci", "-w", "$FILENAME" },
            stdin = false
        },
        shshfmt = {
            command = "shfmt",
            args = { "-i=4", "-ci", "-w", "-ln=bash", "$FILENAME" },
            stdin = false
        },
        yamlfix = {
            command = "yamlfix",
            args = { "--config-file=" .. vim.env.XDG_CONFIG_HOME .. "/nvim/lua/plugins/conform/yaml.toml", "$FILENAME" },
            stdin = false
        }
    },
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,

}

return {
    opts = opts,
}

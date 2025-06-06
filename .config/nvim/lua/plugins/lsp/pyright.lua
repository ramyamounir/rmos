-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
local pyright_configs = {
    settings = {
        pyright = {
            -- using ruff's import organiser
            disableOrganizeImports = true
        },
        python = {
            analysis = {
                -- ignore all files for analysis to execusively use Ruff for linting
                ignore = { '*' },
                -- typeCheckingMode = 'on',
            }
        }
    }
}

return pyright_configs

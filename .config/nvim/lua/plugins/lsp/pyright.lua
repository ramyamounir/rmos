local pyright_configs = {
    settings = {
        pyright = {
            -- using ruff's import organiser
            disableOrganizeImports = true
        },
        python = {
            analysis = {
                -- typeCheckingMode = 'off'
                -- ignore all files for analysis to execusively use Ruff for linting
                ignore = { '*' },
            }
        }
    }
}

return pyright_configs
 

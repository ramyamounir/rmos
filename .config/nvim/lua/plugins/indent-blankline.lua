local function config()
    local status_ok, ibl = pcall(require, 'ibl')
    if not status_ok then return end

    local options = {
        indent = {
            char = "┊",
            tab_char = "┊"
        },
        scope = {
            show_start = false,
            show_end = false,
        }
    }

    ibl.setup(options)
end

return {
    config = config
}

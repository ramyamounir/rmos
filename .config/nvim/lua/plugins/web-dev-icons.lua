local function get_icons()
    local cfg_home = os.getenv("XDG_CONFIG_HOME")

    local file = io.open(cfg_home .. "/lf/icons", "r")

    local override_by_filename = {}
    local override_by_extension = {}

    if file then
        -- Read the entire contents of the file

        local item_type = "SPECIAL"

        for line in file:lines() do
            if line:match("^%s*$") then
            elseif line:match("^%s*#") then
                for TOKEN in line:gsub("^# ", ""):gmatch("%S+") do
                    item_type = TOKEN
                    break
                end
            else
                local items = {}
                for token in line:gmatch("%S+") do
                    table.insert(items, token)
                end
                local fname = items[1]:gsub("^%s*(.-)%s*$", "%1"):gsub("^*", "")
                local icon = items[3]:gsub("\"", ""):gsub("^%s*(.-)%s*$", "%1")
                if item_type == "FILENAMES" then
                    fname = fname:gsub("^%*", "")
                    override_by_filename[fname] = { icon = icon }
                elseif item_type == "EXTENSIONS" then
                    fname = fname:gsub("^%.", "")
                    override_by_extension[fname] = { icon = icon }
                end
            end
        end

        -- Close the file handle
        file:close()
    else
        print("File not found or cannot be opened.")
    end

    return override_by_filename, override_by_extension
end

local override_by_filename, override_by_extension = get_icons()

local opts = {
    default = true,
    strict = true,
    override = {
        default_icon = { icon = "󰈔", name = "DefaultColour" }
    },
    override_by_filename = override_by_filename,
    override_by_extension = override_by_extension,
    global_web_devicons = false,
}

return {
    opts = opts
}


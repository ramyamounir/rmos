
local dependencies = {
    "nvim-tree/nvim-web-devicons",
}

local opts = {
    options = {
        mode = "tabs",
        color_icons = false,
        separator_style = "thin",
        always_show_bufferline = true,
        offsets = {
            {
                filetype = "neo-tree",
                text = "",
                highlight = "Directory",
                text_align = "left",
                padding = 0,
            },
        },
        enforce_regular_tabs = true,
    },
}


return {
  dependencies = dependencies,
  opts = opts,
}

local dependencies = {
    "nvim-tree/nvim-web-devicons",
}

local opts = {
    winopts = {
        width = 0.6,
        height = 0.6,
    },
    fzf_colors = true,
}

return {
    dependencies = dependencies,
    opts = opts
}

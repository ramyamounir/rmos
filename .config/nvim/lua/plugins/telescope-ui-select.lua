local dependencies = { "nvim-telescope/telescope.nvim" }

local function config()
    require("telescope").load_extension("ui-select")
    -- vim.ui.select = require("telescope.themes").get_dropdown {}
end

return {
    dependencies = dependencies,
    config = config,
}

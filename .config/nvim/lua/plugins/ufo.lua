local dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "kevinhwang91/promise-async"
}

local function get_opts()
    local ufo = require('ufo')
    ufo.setup({
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end
    })

    --keymaps
    vim.keymap.set("n", "zm", function() ufo.closeAllFolds() end, { desc = "UFO close all folds" })
    vim.keymap.set("n", "zM", function() ufo.openAllFolds() end, { desc = "UFO open all folds" })
    vim.keymap.set("n", "]]", function() ufo.goNextClosedFold() end, { desc = "UFO go to next closed fold" })
    vim.keymap.set("n", "[[", function() ufo.goPreviousClosedFold() end, { desc = "UFO go to previous closed fold" })
    vim.keymap.set('n', 'zr', function()
        require('ufo').detach()
        require('ufo').attach()
    end, { desc = 'UFO: Refresh Folds' })
end


return {
    dependencies = dependencies,
    opts = get_opts,
}

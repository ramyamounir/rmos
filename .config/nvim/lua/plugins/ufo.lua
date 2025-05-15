local dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "kevinhwang91/promise-async"
}

local function get_opts()
    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end
    })

    vim.api.nvim_set_keymap('n', 'zR', [[<Cmd>lua require('ufo').openAllFolds()<CR>]], { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'zM', [[<Cmd>lua require('ufo').closeAllFolds()<CR>]], { noremap = true, silent = true })

    vim.keymap.set('n', 'zr', function()
        require('ufo').detach()
        require('ufo').attach()
    end, { desc = 'UFO: Refresh Folds' })
end


return {
    dependencies = dependencies,
    opts = get_opts,
}

local dependencies = {
    "kevinhwang91/promise-async"
}

local opts = {

-- Nvim-ufo
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
}

return {
    dependencies = dependencies,
    lazy=false,
    opts = opts,
}

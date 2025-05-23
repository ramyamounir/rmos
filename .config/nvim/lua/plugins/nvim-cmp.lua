local dependencies = {
    "L3MON4D3/LuaSnip",             -- snippet dropdown
    "rafamadriz/friendly-snippets", -- snippet preview
    "hrsh7th/cmp-buffer",           -- buffer
    "hrsh7th/cmp-path",             -- path
    "hrsh7th/cmp-nvim-lsp",         -- language server protocol for neovim
    "Kurama622/llm.nvim"            -- llm plugin
}


-- LuaSnip to expand the snippet
local function expand_snippet(args)
    local status_ok, luasnip = pcall(require, 'luasnip')
    if status_ok then
        require("luasnip/loaders/from_vscode").lazy_load()
        luasnip.lsp_expand(args.body)
    else
        vim.snippet.expand(args.body)
    end
end



local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
    Text = "󰊄",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "󰫧",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "󰌆",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "󰉺",
    llm = "",
}


local function get_mapping(cmp, luasnip)
    local function check_backspace()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end


    return {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<C-g>"] = cmp.mapping(function()
            cmp.complete({
                config = {
                    sources = {
                        { name = "llm" },
                    },
                },
            })
        end, { "i", "c" }),
    }
end

local function config()
    local status_ok, cmp = pcall(require, 'cmp')
    if not status_ok then return end

    local snip_status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then return end

    require("luasnip/loaders/from_vscode").lazy_load()

    local config = {
        snippet = { expand = expand_snippet },
        mapping = get_mapping(cmp, luasnip),
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatinates the icons with the name of the item kind
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    llm = "[AI]",
                    nvim_lua = "[NVIM_LUA]",
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "llm",     group_index = 1,   priority = 100 },
            { name = "nvim_lua" },
            { name = "luasnip", max_item_count = 3 },
            { name = "buffer" },
            { name = "path" },
        },
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        window = {
            documentation = cmp.config.window.bordered(),
        },
        experimental = {
            ghost_text = false,
            native_menu = false,
        },
        enabled = function()
            -- Enable cmp in all buffers except prompt, *except* allow DAP buffers
            return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
                or require("cmp_dap").is_dap_buffer()
        end,
    }

    return config
end


return {
    dependencies = dependencies,
    opts = config,
}

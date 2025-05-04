local function get_opts()
    local Terminal = require("toggleterm.terminal").Terminal

    local rmos = Terminal:new({ cmd = "lazygit -g /home/ramy/.rmos", hidden = true, direction = "float" })
    function _RMOS_TOGGLE() rmos:toggle() end

    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    function _LAZYGIT_TOGGLE() lazygit:toggle() end

    local tbp_monty = Terminal:new({
        cmd = "zsh",
        dir = "/home/ramy/tbp/tbp.monty",
        direction = "float",
        hidden = true,
        on_open = function(term)
            if not term._conda_activated then
                term._conda_activated = true
                vim.defer_fn(function()
                    term:send("a tbp.monty")
                    term:send("clear")
                end, 50)
            end
        end,
    })

    function _TBP_MONTY_TOGGLE()
        tbp_monty:toggle()
    end

    local ncdu = Terminal:new({ cmd = "ncdu", hidden = true, direction = "float" })
    function _NCDU_TOGGLE() ncdu:toggle() end

    local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float" })
    function _HTOP_TOGGLE() htop:toggle() end

    local python = Terminal:new({
        cmd = "python",
        hidden = true,
        direction = "vertical",
        on_open = function(term)
            vim.cmd("vertical resize 80")
        end,
    })
    function _PYTHON_TOGGLE()
        python:toggle()
    end

    -- -- Keymaps
    vim.keymap.set("n", "<leader>rr", _RMOS_TOGGLE, { desc = "Toggle RMOS" })
    vim.keymap.set("n", "<leader>rg", _LAZYGIT_TOGGLE, { desc = "Toggle Lazygit" })
    vim.keymap.set("n", "<leader>rt", _TBP_MONTY_TOGGLE, { desc = "Toggle TBP terminal" })
    vim.keymap.set("n", "<leader>rn", _NCDU_TOGGLE, { desc = "Toggle Ncdu" })
    vim.keymap.set("n", "<leader>rh", _HTOP_TOGGLE, { desc = "Toggle Htop" })
    vim.keymap.set("n", "<leader>rp", _PYTHON_TOGGLE, { desc = "Toggle Python REPL" })

    local opts = {
        size = 20,
        open_mapping = [[<C-Space>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        }
    }
    return opts
end


return {
    version = "*",
    opts = get_opts,
}

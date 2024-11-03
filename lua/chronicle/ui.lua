local ui = {}
local tabs = { "Buffers", "Registers", "Jumps", "Changes" }
local active_tab = 1
local buf

local function render_tab_header()
    local tab_header = ""
    for i, tab_name in ipairs(tabs) do
        if i == active_tab then
            tab_header = tab_header .. string.format(" [ %s ] ", tab_name)
        else
            tab_header = tab_header .. string.format(" %s ", tab_name)
        end
    end
    return tab_header
end

ui.open = function()
    buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        border = 'rounded',
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { render_tab_header(), "------------------------------------------" })
    require('chronicle.buffers').render(buf)

    vim.api.nvim_buf_set_keymap(buf, 'n', 'h', ':lua require("chronicle.ui").switch_tab(-1)<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'l', ':lua require("chronicle.ui").switch_tab(1)<CR>', { noremap = true, silent = true })

    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end

ui.switch_tab = function(direction)
    active_tab = (active_tab + direction - 1) % #tabs + 1
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { render_tab_header(), "" })

    if tabs[active_tab] == "Buffers" then
        require('chronicle.buffers').render(buf)
    elseif tabs[active_tab] == "Registers" then
        require('chronicle.registers').render(buf)
    elseif tabs[active_tab] == "Jumps" then
        require('chronicle.jumps').render(buf)
    elseif tabs[active_tab] == "Changes" then
        require('chronicle.changes').render(buf)
    end
end

return ui

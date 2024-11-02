local ui = {}

ui.open = function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        border = 'rounded',
    })

    -- Render tab headers
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Buffers   | Registers | Jumps     | Changes",
        "------------------------------------------"
    })

    -- Render the initial content (e.g., Buffers)
    require('chronicle.buffers').render(buf)

    -- TODO: Implement tab switching logic
end

return ui

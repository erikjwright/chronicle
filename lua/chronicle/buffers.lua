local buffers = {}

buffers.render = function(win_id)
    local buf_list = require('chronicle.buffers').get_buffers()
    local buf = vim.api.nvim_win_get_buf(win_id)
    local lines = {}

    for _, buffer in ipairs(buf_list) do
        table.insert(lines, string.format("Buffer %d: %s", buffer.bufnr, buffer.name))
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return buffers

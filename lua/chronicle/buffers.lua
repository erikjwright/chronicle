local buffers = {}

function buffers.get_buffers()
    local buffer_list = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            table.insert(buffer_list, {
                bufnr = buf,
                name = vim.api.nvim_buf_get_name(buf),
            })
        end
    end
    return buffer_list
end

function buffers.render(win_id)
    local buf_list = buffers.get_buffers()
    local buf = vim.api.nvim_win_get_buf(win_id)
    local lines = {}

    for _, buffer in ipairs(buf_list) do
        table.insert(lines, string.format("Buffer %d: %s", buffer.bufnr, buffer.name))
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return buffers

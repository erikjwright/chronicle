local jumps = {}

function jumps.get_jumps()
    local jump_list = vim.fn.getjumplist()[1]
    local result = {}

    for _, jump in ipairs(jump_list) do
        table.insert(result, {
            lnum = jump.lnum,
            col = jump.col,
            filename = vim.fn.bufname(jump.bufnr)
        })
    end
    return result
end

function jumps.render(win_id)
    local jump_list = jumps.get_jumps()
    local buf = vim.api.nvim_win_get_buf(win_id)
    local lines = {}

    for _, jump in ipairs(jump_list) do
        table.insert(lines, string.format("Jump to %s [%d:%d]", jump.filename, jump.lnum, jump.col))
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return jumps

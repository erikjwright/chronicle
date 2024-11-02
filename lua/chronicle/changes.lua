local changes = {}

changes.get_changes = function()
    local change_list = vim.fn.changes()
    local result = {}

    for _, change in ipairs(change_list) do
        table.insert(result, {
            lnum = change.lnum,
            col = change.col,
            text = vim.api.nvim_buf_get_lines(change.bufnr, change.lnum - 1, change.lnum, false)[1]
        })
    end
    return result
end

changes.render = function(win_id)
    local change_list = changes.get_changes()
    local buf = vim.api.nvim_win_get_buf(win_id)
    local lines = {}

    for _, change in ipairs(change_list) do
        table.insert(lines, string.format("Change at [%d:%d]: %s", change.lnum, change.col, change.text))
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return changes

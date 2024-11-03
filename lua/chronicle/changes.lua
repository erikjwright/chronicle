-- ./lua/chronicle/changes.lua
local changes = {}

function changes.render(buf)
    local change_list = vim.fn.split(vim.fn.execute("changes"), "\n")
    local lines = { "=== Change List ===" }

    for i = 2, #change_list do
        table.insert(lines, change_list[i])
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return changes

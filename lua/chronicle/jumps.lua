-- ./lua/chronicle/jumps.lua
local jumps = {}

function jumps.render(buf)
    local jump_list = vim.fn.split(vim.fn.execute("jumps"), "\n")
    local lines = { "=== Jump List ===" }

    for i = 2, #jump_list do
        table.insert(lines, jump_list[i])
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return jumps


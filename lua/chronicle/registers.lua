local registers = {}

function registers.get_registers()
    local reg_list = {}
    for _, reg in ipairs({ '"', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', ':', '.', '/', '*', '+' }) do
        local content = vim.fn.getreg(reg)
        if content and content ~= '' then
            table.insert(reg_list, {
                reg = reg,
                content = content,
            })
        end
    end
    return reg_list
end

function registers.render(win_id)
    local reg_list = registers.get_registers()
    local buf = vim.api.nvim_win_get_buf(win_id)
    local lines = {}

    for _, reg in ipairs(reg_list) do
        table.insert(lines, string.format("Register %s: %s", reg.reg, reg.content))
    end

    vim.api.nvim_buf_set_lines(buf, 2, -1, false, lines)
end

return registers


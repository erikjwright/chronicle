local M = {}

M.setup = function()
    vim.api.nvim_create_user_command('ChronicleOpen', function()
        require('chronicle.ui').open()
    end, {})
end

return M

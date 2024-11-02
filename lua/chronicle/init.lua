local M = {}

M.setup = function()
    vim.api.nvim_command('command! ChronicleOpen lua require("chronicle.ui").open()')
end

return M

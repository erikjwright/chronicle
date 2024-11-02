-- Ensure no error-prone code is present in the function
local float = require('plenary.window.float')

local M = {}

function M.create_floating_window()
  local result = float.percentage_range_window(0.8, 0.6, {
    border = 'rounded',
    winblend = 10,
    title = 'Chronicle Info Panel'
  })

  local buf = result.buf
  local win = result.win

  if not buf or type(buf) ~= "number" then
    vim.api.nvim_err_writeln("Failed to create buffer")
    return
  end

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  local buffer_lines = {
    "=== Test Content ===",
    "This is a simple test to verify the plugin functionality."
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  return win
end

vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_floating_window()
end, {})

return M

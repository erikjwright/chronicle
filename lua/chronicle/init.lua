-- Ensure that Plenary is installed
local float = require('plenary.window.float')

local M = {}

-- Function to create and display a floating window with minimal content
function M.create_floating_window()
  -- Create a floating window using Plenary's float utility
  local result = float.percentage_range_window(0.8, 0.6, {
    border = 'rounded',  -- Rounded border for aesthetics
    winblend = 10,       -- Transparency effect
    title = 'Chronicle Info Panel'
  })

  local buf = result.buf
  local win = result.win

  -- Check if buf was created successfully
  if not buf or type(buf) ~= "number" then
    vim.api.nvim_err_writeln("Failed to create buffer")
    return
  end

  -- Set key mapping for closing the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  -- Initialize buffer content with minimal content for testing
  local buffer_lines = {
    "=== Test Content ===",
    "This is a simple test to verify the plugin functionality."
  }

  -- Populate the buffer with the test content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_lines)

  -- Set the buffer to be non-modifiable
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  return win
end

-- Register the command to trigger the floating window
vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_floating_window()
end, {})

return M

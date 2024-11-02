local M = {}

-- Function to create and display a floating window with basic Neovim API
function M.create_floating_window()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)  -- Create an unlisted, scratch buffer

  -- Check if buf was created successfully
  if not buf or type(buf) ~= "number" then
    vim.api.nvim_err_writeln("Failed to create buffer")
    return
  end

  -- Get the dimensions of the current Neovim window
  local width = vim.o.columns
  local height = vim.o.lines

  -- Define the size and position of the floating window
  local win_width = math.ceil(width * 0.8)
  local win_height = math.ceil(height * 0.6)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',  -- Add border for aesthetics
  })

  -- Set key mapping for closing the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  -- Populate the buffer with simple content
  local buffer_lines = {
    "=== Test Content ===",
    "This is a simple test to verify that only intended content is displayed.",
    "If you see this, the plugin is working as expected."
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  return win
end

-- Register the command to trigger the floating window
vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_floating_window()
end, {})

return M

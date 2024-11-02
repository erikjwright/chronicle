-- Ensure that Plenary is installed
local float = require('plenary.window.float')

local M = {}

-- Function to create and display a floating window with dynamic content
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
  if buf == nil or type(buf) ~= "number" then
    vim.api.nvim_err_writeln("Failed to create buffer")
    return
  end

  -- Set key mapping for closing the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  -- Gather content dynamically
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  local buffer_lines = {"=== Buffers ==="}
  for _, buffer in ipairs(buffers) do
    table.insert(buffer_lines, string.format("Buffer %d: %s", buffer.bufnr, buffer.name ~= "" and buffer.name or "[No Name]"))
  end

  table.insert(buffer_lines, "")
  table.insert(buffer_lines, "=== Registers ===")
  for i = 0, 9 do
    local reg_content = vim.fn.getreg(tostring(i))
    if reg_content ~= "" then
      table.insert(buffer_lines, string.format("Register %d: %s", i, reg_content))
    end
  end

  table.insert(buffer_lines, "")
  table.insert(buffer_lines, "=== Jump List ===")
  local jumps = vim.fn.split(vim.fn.execute("jumps"), "\n")
  for i = 2, #jumps do
    table.insert(buffer_lines, jumps[i])
  end

  table.insert(buffer_lines, "")
  table.insert(buffer_lines, "=== Change List ===")
  local changes = vim.fn.split(vim.fn.execute("changes"), "\n")
  for i = 2, #changes do
    table.insert(buffer_lines, changes[i])
  end

  -- Populate the buffer with the collected information
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_lines)

  -- Set the buffer to be modifiable (if needed for further updates)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Return the window handle for further customization if needed
  return win
end

-- Register the command to trigger the floating window
vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_floating_window()
end, {})

return M

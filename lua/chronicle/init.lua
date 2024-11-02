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
  if not buf or type(buf) ~= "number" then
    vim.api.nvim_err_writeln("Failed to create buffer")
    return
  end

  -- Set key mapping for closing the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  -- Initialize buffer content
  local buffer_lines = {}

  -- Helper function to sanitize lines
  local function sanitize_line(line)
    return line:gsub("[^%w%s%p]", "")  -- Removes non-alphanumeric, non-space, non-punctuation characters
  end

  -- Populate the buffer with information about buffers
  table.insert(buffer_lines, "=== Buffers ===")
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  for _, buffer in ipairs(buffers) do
    local buffer_name = buffer.name ~= "" and buffer.name or "[No Name]"
    local line = string.format("Buffer %d: %s", buffer.bufnr, buffer_name)
    table.insert(buffer_lines, sanitize_line(line))
  end

  -- Add a separator and register content
  table.insert(buffer_lines, "")
  table.insert(buffer_lines, "=== Registers ===")
  for i = 0, 9 do
    local reg_content = vim.fn.getreg(tostring(i))
    if reg_content ~= "" then
      local line = string.format("Register %d: %s", i, reg_content)
      table.insert(buffer_lines, sanitize_line(line))
    end
  end

  -- Add a separator and jump list content
  table.insert(buffer_lines, "")
  table.insert(buffer_lines, "=== Jump List ===")
  local jumps = vim.fn.split(vim.fn.execute("jumps"), "\n")
  for i = 2, #jumps do
    local line = jumps[i]
    table.insert(buffer_lines, sanitize_line(line))
  end

  -- Add a separator and change list content
  table.insert(buffer_lines, "")
  table.insert(buffer_lines, "=== Change List ===")
  local changes = vim.fn.split(vim.fn.execute("changes"), "\n")
  for i = 2, #changes do
    local line = changes[i]
    table.insert(buffer_lines, sanitize_line(line))
  end

  -- Populate the buffer with the collected information
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_lines)

  -- Set the buffer to be non-modifiable
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Return the window handle for further customization if needed
  return win
end

-- Register the command to trigger the floating window
vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_floating_window()
end, {})

return M

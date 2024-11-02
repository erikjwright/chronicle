local M = {}

-- Function to create and display a floating window with tabs
function M.create_tabbed_window()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)  -- Create an unlisted, scratch buffer

  -- Check if the buffer was created successfully
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
    border = 'rounded',
  })

  -- Set up tab titles
  local tabs = { "Buffers", "Registers", "Jumps", "Changes" }
  local active_tab = 1

  -- Function to populate content based on the active tab
  local function populate_content(tab_index)
    local buffer_lines = {}

    if tab_index == 1 then
      table.insert(buffer_lines, "=== Buffers ===")
      local buffers = vim.fn.getbufinfo({buflisted = 1})
      for _, buffer in ipairs(buffers) do
        local buffer_name = buffer.name ~= "" and buffer.name or "[No Name]"
        table.insert(buffer_lines, string.format("Buffer %d: %s", buffer.bufnr, buffer_name))
      end
    elseif tab_index == 2 then
      table.insert(buffer_lines, "=== Registers ===")
      for i = 0, 9 do
        local reg_content = vim.fn.getreg(tostring(i))
        if reg_content ~= "" then
          table.insert(buffer_lines, string.format("Register %d: %s", i, reg_content))
        end
      end
    elseif tab_index == 3 then
      table.insert(buffer_lines, "=== Jump List ===")
      local jumps = vim.fn.split(vim.fn.execute("jumps"), "\n")
      for i = 2, #jumps do
        table.insert(buffer_lines, jumps[i])
      end
    elseif tab_index == 4 then
      table.insert(buffer_lines, "=== Change List ===")
      local changes = vim.fn.split(vim.fn.execute("changes"), "\n")
      for i = 2, #changes do
        table.insert(buffer_lines, changes[i])
      end
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, buffer_lines)
  end

  -- Function to switch tabs
  local function switch_tab(direction)
    active_tab = active_tab + direction
    if active_tab < 1 then
      active_tab = #tabs
    elseif active_tab > #tabs then
      active_tab = 1
    end
    populate_content(active_tab)
  end

  -- Populate initial content for the first tab
  populate_content(active_tab)

  -- Key mappings to navigate between tabs
  vim.api.nvim_buf_set_keymap(buf, 'n', 'h', ':lua require("chronicle").switch_tab(-1)<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'l', ':lua require("chronicle").switch_tab(1)<CR>', { noremap = true, silent = true })

  -- Set the buffer to be non-modifiable
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  return win
end

-- Function to switch tabs from key mapping
function M.switch_tab(direction)
  -- Implement logic here if you need an external function call for tab switching
end

-- Register the command to trigger the floating window
vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_tabbed_window()
end, {})

return M

local M = {}

-- Define tabs and active_tab at the module level so they are accessible by all functions
local tabs = { "Buffers", "Registers", "Jumps", "Changes" }
local active_tab = 1
local buf

-- Function to create and display a floating window with tabs
function M.create_tabbed_window()
  buf = vim.api.nvim_create_buf(false, true)

  if not buf or type(buf) ~= "number" then
    vim.api.nvim_err_writeln("Failed to create buffer")
    return
  end

  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = math.ceil(width * 0.8)
  local win_height = math.ceil(height * 0.6)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    winblend = 10,
    winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
  })

  -- Add tab headers at the top of the buffer
  local tab_header = ""
  for i, tab_name in ipairs(tabs) do
    if i == active_tab then
      tab_header = tab_header .. string.format("%%#TelescopePromptPrefix# [%s] ", tab_name)
    else
      tab_header = tab_header .. string.format("[%s] ", tab_name)
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { tab_header })

  -- Populate initial content for the first tab
  M.populate_content(active_tab)

  -- Key mappings for switching tabs
  vim.api.nvim_buf_set_keymap(buf, 'n', 'h', ':lua require("chronicle").switch_tab(-1)<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'l', ':lua require("chronicle").switch_tab(1)<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  return win
end

-- Function to populate content based on the active tab
function M.populate_content(tab_index)
  local buffer_lines = {}

  -- Add tab header
  local tab_header = ""
  for i, tab_name in ipairs(tabs) do
    if i == active_tab then
      tab_header = tab_header .. string.format("%%#TelescopePromptPrefix# [%s] ", tab_name)
    else
      tab_header = tab_header .. string.format("[%s] ", tab_name)
    end
  end
  table.insert(buffer_lines, tab_header)
  table.insert(buffer_lines, "")  -- Add an empty line for separation

  -- Populate content based on the selected tab
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

-- Function to switch tabs, called by the key mapping
function M.switch_tab(direction)
  active_tab = active_tab + direction
  if active_tab < 1 then
    active_tab = #tabs
  elseif active_tab > #tabs then
    active_tab = 1
  end
  M.populate_content(active_tab)
end

vim.api.nvim_create_user_command('OpenFloatInfo', function()
  M.create_tabbed_window()
end, {})

return M

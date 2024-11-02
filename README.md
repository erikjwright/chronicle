# Chronicle

A Neovim plugin that creates a floating window displaying buffers, registers, jumps, and changes.

## Features
- Display information about:
  - Buffers
  - Registers
  - Jump list
  - Change list
- Interactive floating window with border and transparency.

## Installation

### Lazy.nvim
```lua
return {
  {
    'erikjwright/chronicle',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
      require('chronicle')
    end,
    lazy = true,
    cmd = 'OpenFloatInfo',
    keys = {
      { '<leader>fi', ':OpenFloatInfo<CR>', desc = 'Open Floating Info' },
    }
  }
}
```



-- lua/plugins/colorscheme.lua

return {
  -- The plugin that listens for the system's theme change
  {
    'cormacrelf/dark-notify',
    config = function()
      -- The `onchange` function is called whenever the system theme changes.
      -- `mode` will be either "dark" or "light".
      require('dark_notify').run {
        onchange = function(mode)
          -- This is the key: we simply set Neovim's background option.
          -- Colorschemes like Cyberdream, Catppuccin, Tokyonight, etc.,
          -- will automatically detect this change and switch their variant.
          vim.o.background = mode
        end,
      }
    end,
  },

  -- Your colorscheme plugin
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('cyberdream').setup {
        -- 'auto' will now correctly follow vim.o.background
        variant = 'auto',
        transparent = true,
        italic_comments = true,
        borderless_telescope = false,
      }
      -- Load the colorscheme
      vim.cmd.colorscheme 'cyberdream'

      -- The keybinding to toggle manually is still useful for testing
      vim.keymap.set(
        'n',
        '<leader>tc',
        ':CyberdreamToggleMode<CR>',
        { noremap = true, silent = true, desc = 'Toggle Colorscheme' }
      )
    end,
  },
}

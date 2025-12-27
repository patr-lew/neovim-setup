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
          if mode == 'light' then
            vim.cmd [[colorscheme tokyonight-day]]
          else
            vim.cmd [[colorscheme tokyonight-storm]]
          end
        end,
      }
    end,
  },

  -- Your colorscheme plugin

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'storm', -- or night, day, moon
      light_style = 'day',
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
      },
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)

      local function apply_overrides()
        local c = require('tokyonight.colors').setup()
        local hl = vim.api.nvim_set_hl

        hl(0, '@function', { fg = c.blue, bold = true })
        hl(0, '@function.call', { fg = c.blue })
        hl(0, '@method', { fg = c.magenta })
        hl(0, '@method.call', { fg = c.magenta })
        hl(0, '@type', { fg = c.cyan })
        hl(0, '@type.builtin', { fg = c.cyan, italic = true })
        hl(0, '@constant', { fg = c.yellow })
        hl(0, '@constant.builtin', { fg = c.orange })
        hl(0, '@namespace', { fg = c.green })
        hl(0, '@module', { fg = c.teal })

        -- Invert heading colors globally so render-markdown + treesitter-context match.
        for level = 1, 6 do
          local ts_group = string.format('@markup.heading.%d.markdown', level)
          local ts_hl = vim.api.nvim_get_hl(0, { name = ts_group, link = true })
          local bg = ts_hl.fg or c.fg
          local fg = c.bg
          local attrs = {
            fg = fg,
            bg = bg,
            bold = ts_hl.bold,
            italic = ts_hl.italic,
            underline = ts_hl.underline,
            undercurl = ts_hl.undercurl,
            strikethrough = ts_hl.strikethrough,
          }
          hl(0, ts_group, attrs)
          hl(0, string.format('RenderMarkdownH%d', level), attrs)
          hl(0, string.format('RenderMarkdownH%dBg', level), { bg = bg })
        end

        hl(0, 'RenderMarkdownCodeBorder', { bg = c.bg_highlight })
      end

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = apply_overrides,
      })

      vim.cmd.colorscheme 'tokyonight'
      apply_overrides()
    end,
  },
  -- {
  --   'scottmckendry/cyberdream.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('cyberdream').setup {
  --       -- 'auto' will now correctly follow vim.o.background
  --       variant = 'auto',
  --       transparent = true,
  --       italic_comments = true,
  --       borderless_telescope = false,
  --     }
  --     -- Load the colorscheme
  --     vim.cmd.colorscheme 'cyberdream'
  --
  --     -- The keybinding to toggle manually is still useful for testing
  --     vim.keymap.set(
  --       'n',
  --       '<leader>tc',
  --       ':CyberdreamToggleMode<CR>',
  --       { noremap = true, silent = true, desc = 'Toggle Colorscheme' }
  --     )
  --   end,
  -- },
}

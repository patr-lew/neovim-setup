return {
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      preset = {
        header = [[

  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                     ]],
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    explorer = {
      -- Override default keymaps
      win = {
        keys = {
          -- Make "o" behave like Enter/l - expand directories and open files
          o = 'open',
          -- Move system open to capital O
          O = 'system_open',
          -- Grep in current directory
          ['g/'] = {
            function()
              local file = Snacks.explorer.state():focused()
              if file then
                local dir = file.is_dir and file.path
                  or vim.fn.fnamemodify(file.path, ':h')
                require('telescope.builtin').live_grep { cwd = dir }
              end
            end,
            desc = 'Grep in directory',
          },
          ['gt'] = {
            function()
              local file = Snacks.explorer.state():focused()
              if file then
                local dir = file.is_dir and file.path
                  or vim.fn.fnamemodify(file.path, ':h')
                require('neotest').run.run(dir)
              end
            end,
            desc = 'Run Neotest in directory',
          },
        },
      },
    },
  },
}

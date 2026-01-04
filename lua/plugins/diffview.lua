return {
  {
    'sindrets/diffview.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },

    keys = {
      {
        '<leader>gd',
        function()
          require('diffview').open { 'HEAD^' }
        end,
        desc = 'Diff since prev commit',
      },
      {
        '<leader>gD',
        function()
          require('diffview').open { 'HEAD' }
        end,
        desc = 'Diff uncommitted (staged + unstaged)',
      },
      {
        '<leader>gm',
        function()
          require('diffview').open { 'main' }
        end,
        desc = 'Diff against main',
      },
    },
  },
}

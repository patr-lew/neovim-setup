return {
  { 'rcarriga/nvim-notify', opts = {
    top_down = false,
  } },
  {
    'folke/noice.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- add any options here
      views = {
        notify = {
          position = 'bottom-right',
          timeout = 3000,
        },
      },
    },
    keys = {
      {
        '<leader>sn',
        function()
          require('telescope').extensions.notify.notify()
        end,
        desc = 'Go through notifications',
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
}

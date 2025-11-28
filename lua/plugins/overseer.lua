return {
  {
    'stevearc/overseer.nvim',
    opts = {
      task_list = {
        direction = 'bottom',
        bindings = {
          ['<C-h>'] = false,
          ['<C-j>'] = false,
          ['<C-k>'] = false,
          ['<C-l>'] = false,
          ['L'] = 'IncreaseDetail',
          ['H'] = 'DecreaseDetail',
          ['<PageUp>'] = 'ScrollOutputUp',
          ['<PageDown>'] = 'ScrollOutputDown',
        },
      },
    },
    config = function(_, opts)
      require('overseer').setup(opts)
      -- Ensure window navigation works inside Overseer buffers
      local function map_nav(buf)
        local opts = { silent = true, noremap = true, buffer = buf }
        vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
        vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
        vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
        vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
      end
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'OverseerList', 'OverseerOutput' },
        callback = function(args)
          map_nav(args.buf)
        end,
      })
    end,
    keys = {
      {
        '<leader>ot',
        '<cmd>OverseerToggle<CR>',
        desc = 'Toggle Overseer Task List',
      },
      { '<leader>or', '<cmd>OverseerRun<CR>', desc = 'Run Overseer Task' },
      {
        '<leader>ol',
        '<cmd>OverseerRunCmd<CR>',
        desc = 'Run Command in Overseer',
      },
      {
        '<leader>oq',
        '<cmd>OverseerQuickAction<CR>',
        desc = 'Quick Action for Overseer Task',
      },
      {
        '<leader>oa',
        '<cmd>OverseerTaskAction<CR>',
        desc = 'Select and Act on Overseer Task',
      },
      {
        '<leader>oc',
        '<cmd>OverseerClearCache<CR>',
        desc = 'Clear Overseer Task Cache',
      },
      {
        '<leader>os',
        '<cmd>OverseerSaveBundle<CR>',
        desc = 'Save Overseer Task Bundle',
      },
      {
        '<leader>oS',
        '<cmd>OverseerShell<CR>',
        desc = 'Run shell in Overseer',
      },
      {
        '<leader>ob',
        '<cmd>OverseerLoadBundle<CR>',
        desc = 'Load Overseer Task Bundle',
      },
    },
  }
}

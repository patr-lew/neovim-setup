return {
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp_cfg = false, -- Disable go.nvim's LSP config, use LazyVim's gopls setup instead
      lsp_keymaps = false, -- Disable go.nvim LSP keymaps, use LazyVim's instead
      -- other options
    },
    config = function(lp, opts)
      require('go').setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end,
    keys = {
      -- Struct tags
      { '<leader>cgj', '<cmd>GoAddTag json<cr>', desc = 'Add json tags', ft = 'go' },
      { '<leader>cgy', '<cmd>GoAddTag yaml<cr>', desc = 'Add yaml tags', ft = 'go' },
      { '<leader>cgr', '<cmd>GoRmTag<cr>', desc = 'Remove tags', ft = 'go' },

      -- Code generation
      { '<leader>cge', '<cmd>GoIfErr<cr>', desc = 'Add if err', ft = 'go' },
      { '<leader>cgs', '<cmd>GoFillStruct<cr>', desc = 'Fill struct', ft = 'go' },
      { '<leader>cgw', '<cmd>GoFillSwitch<cr>', desc = 'Fill switch', ft = 'go' },

      -- Tests
      { '<leader>cgt', '<cmd>GoAddTest<cr>', desc = 'Add test', ft = 'go' },
      { '<leader>cgT', '<cmd>GoAddAllTest<cr>', desc = 'Add all tests', ft = 'go' },

      -- Interface & docs
      { '<leader>cgi', '<cmd>GoImpl<cr>', desc = 'Implement interface', ft = 'go' },
      { '<leader>cgd', '<cmd>GoDoc<cr>', desc = 'Go doc', ft = 'go' },
    },
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}

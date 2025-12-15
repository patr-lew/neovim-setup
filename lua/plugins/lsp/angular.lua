return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      angularls = {
        cmd = {
          'ngserver',
          '--stdio',
          '--tsProbeLocations',
          vim.fn.getcwd() .. '/node_modules',
          '--ngProbeLocations',
          vim.fn.expand '~/.nvm/versions/node/v24.11.1/lib/node_modules/@angular/language-server/node_modules',
        },
        on_attach = function(client, bufnr)
          require('lspconfig').common_on_attach(client, bufnr)
        end,
        filetypes = { 'html', 'typescript', 'javascript' },
        root_dir = require('lspconfig/util').root_pattern '.git',
        settings = {
          angular = {},
        },
      },
      vtsls = {
        root_dir = require('lspconfig/util').root_pattern '.git',
      },
      ts_ls = {
        root_dir = require('lspconfig/util').root_pattern '.git',
      },
      eslint = {
        root_dir = require('lspconfig/util').root_pattern '.git',
      },
    },
  },
}

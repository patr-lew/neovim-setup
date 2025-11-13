return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      angularls = {
        cmd = { 
          'ngserver', 
          '--stdio', 
          '--tsProbeLocations', vim.fn.getcwd() .. '/node_modules',
          '--ngProbeLocations', vim.fn.expand('~/.nvm/versions/node/v22.16.0/lib/node_modules/@angular/language-server/node_modules')
        },
        on_attach = function(client, bufnr)
          require('lspconfig').common_on_attach(client, bufnr)
        end,
        filetypes = { 'html', 'typescript', 'javascript' },
        root_dir = require('lspconfig/util').root_pattern(
          'angular.json',
          '.git'
        ),
        settings = {
          angular = {},
        },
      },
    },
  },
}

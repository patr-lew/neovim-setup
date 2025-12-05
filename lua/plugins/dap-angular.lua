return {
  {
    'mfussenegger/nvim-dap',
    optional = true,
    config = function()
      local dap = require 'dap'
      -- Configure js-debug-adapter (pwa-chrome)
      dap.adapters['pwa-chrome'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        },
      }

      -- Angular/Chrome configurations for TypeScript
      dap.configurations.typescript = {
        {
          name = 'Launch Angular in Chrome',
          type = 'pwa-chrome',
          request = 'launch',
          url = 'https://localhost:4203',
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*',
          },
        },
        {
          name = 'Attach to Chrome',
          type = 'pwa-chrome',
          request = 'attach',
          port = 9222,
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*',
          },
        },
      }

      -- Same configs for JavaScript
      dap.configurations.javascript = dap.configurations.typescript
      dap.configurations.typescriptreact = dap.configurations.typescript
      dap.configurations.javascriptreact = dap.configurations.typescript
    end,
  },
}

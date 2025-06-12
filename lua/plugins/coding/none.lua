return {
  'nvimtools/none-ls.nvim',
  -- Just by listing this as a dependency, its sources become available.
  dependencies = { 'nvimtools/none-ls-extras.nvim' },

  opts = function()
    -- We only need to require the main module, which is still 'null-ls'.
    local nls = require 'null-ls'

    -- There is NO need to require 'none-ls.extras.*'.
    -- The sources from the extras plugin are merged into the 'nls' object.

    return {
      sources = {
        -- Linters
        nls.builtins.diagnostics.kube_linter,
        nls.builtins.diagnostics.hadolint,
        nls.builtins.diagnostics.ruff,

        -- ESLint is now accessed directly through `nls.builtins`, just like the others.
        nls.builtins.diagnostics.eslint_d.with {
          fallback_config = {
            parserOptions = {
              ecmaVersion = 'latest',
              sourceType = 'module',
              ecmaFeatures = { jsx = true },
            },
            env = {
              ['react-native/react-native'] = true,
              ['node'] = true,
              ['es2021'] = true,
            },
            plugins = { 'react-native' },
            rules = {
              ['no-undef'] = 'warn',
              ['no-unused-vars'] = 'warn',
            },
          },
        },

        -- Formatters
        -- prettierd also comes from the extras plugin and is accessed directly.
        nls.builtins.formatting.prettierd,
        nls.builtins.formatting.stylua,
      },

      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = 'LspFormat', buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = 'LspFormat',
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr, async = false }
            end,
          })
        end
      end,
    }
  end,

  config = function(_, opts)
    -- This keymap setup is perfect and runs after the plugin is configured.
    vim.keymap.set(
      'n',
      '<leader>cf',
      vim.lsp.buf.format,
      { desc = '[C]ode [F]ormat file' }
    )
  end,
}

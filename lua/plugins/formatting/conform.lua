-- In lua/plugins/conform.lua
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    -- Use the modern format_on_save table
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback', -- Fallback to LSP formatter if conform fails
    },

    -- Combine all your formatters in one place
    formatters_by_ft = {
      -- From your conform.lua
      lua = { 'stylua' },
      php = { 'php_cs_fixer' },
      blade = { 'blade-formatter' },

      -- From your prettier.lua
      css = { 'prettier' },
      graphql = { 'prettier' },
      handlebars = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      less = { 'prettier' },
      scss = { 'prettier' },
      vue = { 'prettier' },
      yaml = { 'prettier' },

      -- From your astro.lua
      astro = { 'prettier' },

      -- Unified JS/TS formatting
      -- Using prettier as primary and eslint_d as a fallback or secondary
      javascript = { 'prettier', 'eslint_d' },
      javascriptreact = { 'prettier', 'eslint_d' },
      typescript = { 'prettier', 'eslint_d' },
      typescriptreact = { 'prettier', 'eslint_d' },
    },
  },
}

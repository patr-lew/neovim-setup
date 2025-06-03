return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'php_cs_fixer' },
        blade = { 'blade-formatter' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      },
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
    },
  },
}

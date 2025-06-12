return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      -- You can add sources for any tool that none-ls supports
      sources = {
        -- Linters
        null_ls.builtins.diagnostics.kube_linter,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.ruff,

        -- Formatters
        null_ls.builtins.formatting.stylua,
      },

      -- This function will format the buffer on save.
      -- You can disable this if you prefer to format manually.
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

    -- Optional: a keymap to trigger formatting manually
    vim.keymap.set(
      'n',
      '<leader>cf',
      vim.lsp.buf.format,
      { desc = 'Format file' }
    )
  end,
}

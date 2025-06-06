-- This file is the central configuration for all things TypeScript/JavaScript.
-- It uses `pmizio/typescript-tools.nvim` to provide a comprehensive and robust
-- development experience, replacing the need for a separate `tsserver` or `vtsls` setup.
-- It also includes configurations for Astro and Vue, which rely on the TS server.

return {
  'pmizio/typescript-tools.nvim',

  -- Defer loading of the plugin until a relevant file is opened.
  -- This improves Neovim's startup time.
  ft = {
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'vue',
    'astro',
  },

  -- These are the required dependencies for the plugin to work correctly.
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },

  -- The `opts` table is where all configuration goes.
  -- lazy.nvim passes this table to the plugin's `setup()` function.
  opts = {
    -- The `on_attach` function runs whenever the LSP server attaches to a buffer.
    -- This is the ideal place to set up buffer-local keymaps for LSP functionality.
    on_attach = function(client, bufnr)
      -- It's recommended to call the plugin's default on_attach function.
      -- This sets up some useful default behavior and commands.
      require('typescript-tools').default_on_attach(client, bufnr)

      -- Helper function to create keymaps concisely.
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, {
          buffer = bufnr,
          noremap = true,
          silent = true,
          desc = 'LSP: ' .. desc,
        })
      end

      -- ======================================================================
      -- Standard LSP Keymaps (useful for any language server)
      -- ======================================================================
      map('gd', vim.lsp.buf.definition, 'Go to Definition')
      map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
      map('gI', vim.lsp.buf.implementation, 'Go to Implementation')
      map('gr', vim.lsp.buf.references, 'Go to References')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
      map('<leader>cs', vim.lsp.buf.signature_help, 'Signature Help')

      -- Diagnostics
      map('[d', vim.diagnostic.get_prev, 'Go to Previous Diagnostic')
      map(']d', vim.diagnostic.get_next, 'Go to Next Diagnostic')
      map('<leader>cd', vim.diagnostic.open_float, 'Show Line Diagnostics')

      -- Refactoring
      map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
      map('<leader>crn', vim.lsp.buf.rename, 'Rename')

      -- ======================================================================
      -- Keymaps specific to `typescript-tools.nvim`
      -- ======================================================================
      map('<leader>co', ':TypescriptOrganizeImports<CR>', 'Organize Imports')
      map(
        '<leader>ci',
        ':TypescriptAddMissingImports<CR>',
        'Add Missing Imports'
      )
      map('<leader>cf', ':TypescriptFixAll<CR>', 'Fix All Diagnostics')
      map(
        '<leader>cR',
        ':TypescriptRenameFile<CR>',
        'Rename File and Update Imports'
      )
    end,

    -- The `settings` table contains plugin-specific options.
    settings = {
      -- Tell `tsserver` to load plugins for other filetypes to enhance its capabilities.
      tsserver_plugins = {
        -- This plugin makes the TS server understand `.astro` file imports.
        {
          name = '@astrojs/ts-plugin',
          location = vim.fn.stdpath 'data'
            .. '/mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin',
          enableForWorkspaceTypeScriptVersions = true,
        },
        -- This plugin makes the TS server understand `.vue` file imports.
        {
          name = '@vue/typescript-plugin',
          location = vim.fn.stdpath 'data'
            .. '/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin',
          enableForWorkspaceTypeScriptVersions = true,
        },
      },

      -- Configuration for inlay hints (the gray text that shows variable types, etc.).
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all', -- 'none', 'literals', 'all'
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },

      -- Let `typescript-tools` handle formatting.
      -- Ensure 'prettier' is in your `mason-tool-installer` list.
      formatter = 'prettier',

      -- Let `typescript-tools` handle linting with ESLint.
      -- Ensure 'eslint' is in your `mason-tool-installer` list.
      -- Using 'eslint_d' provides a significant performance boost.
      lint_bin = 'eslint_d',
      lint_enable_diagnostics = true,

      -- You can also configure other top-level options from the plugin's setup
      -- For example, to disable the inlay hint virtual text:
      -- inlay_hints = {
      --   enabled = false
      -- },
    },
  },
}

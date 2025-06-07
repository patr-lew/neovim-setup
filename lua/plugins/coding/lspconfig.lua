-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup(
          'kickstart-lsp-attach',
          { clear = true }
        ),
        callback = function(event)
          -- A helper function to easily define keymaps for the current buffer.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(
              mode,
              keys,
              func,
              { buffer = event.buf, desc = desc }
            )
          end

          -- Execute a code action.
          map(
            '<leader>ca',
            vim.lsp.buf.code_action,
            'Code Action',
            { 'n', 'x' }
          )

          -- Go to Declaration.
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          -- Highlight references of the word under your cursor.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client.supports_method(
              vim.lsp.protocol.Methods.textDocument_documentHighlight
            )
          then
            local highlight_augroup = vim.api.nvim_create_augroup(
              'kickstart-lsp-highlight',
              { clear = false }
            )
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup(
                'kickstart-lsp-detach',
                { clear = true }
              ),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                  group = 'kickstart-lsp-highlight',
                  buffer = event2.buf,
                }
              end,
            })
          end

          -- Toggle inlay hints.
          if
            client
            and client.supports_method(
              vim.lsp.protocol.Methods.textDocument_inlayHint
            )
          then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
              )
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      vim.diagnostic.config {
        virtual_text = true, -- enable inline diagnostics
        signs = true,
      }
      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs =
          { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end

      -- Add nvim-cmp and other capabilities to the LSP client
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      ------------------------------------------------------------------
      -- CONFIGURE TOOLS
      ------------------------------------------------------------------
      -- This is the new, organized structure.
      -- `servers` contains ONLY Language Servers for mason-lspconfig.
      -- `other_tools` contains linters, formatters, debuggers, etc. for mason-tool-installer.

      -- LSPs with any custom configuration.
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        -- LSPs with default configuration. They will be automatically installed and configured.
        astro = {},
        biome = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {},
        neocmake = {},
        pyright = {},
        tailwindcss = {},
        gitlab_ci_ls = {},
        yamlls = {},
      }

      -- Other tools (not LSPs) to be installed by Mason.
      local other_tools = {
        -- Debuggers
        'debugpy', -- Python
        'delve', -- Go
        'js-debug-adapter', -- JS/TS

        -- Linters
        'hadolint', -- Dockerfile
        'ruff', -- Python
        'kube-linter',

        -- Formatters
        'prettier',
        'prettierd',
        'stylua', -- Lua
      }

      -- Get just the names of the LSP servers.
      local lsp_server_names = vim.tbl_keys(servers)

      -- Setup mason-tool-installer to install ALL tools (LSPs + others).
      require('mason-tool-installer').setup {
        ensure_installed = vim.list_extend(
          vim.deepcopy(lsp_server_names),
          other_tools
        ),
      }

      -- Setup mason-lspconfig to configure ONLY the LSPs.
      -- This is the key change that fixes the error message.
      require('mason-lspconfig').setup {
        ensure_installed = lsp_server_names,
        automatic_enable = true,
        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}
            -- This handles overriding only values explicitly passed in the `servers` table.
            server_opts.capabilities = vim.tbl_deep_extend(
              'force',
              {},
              capabilities,
              server_opts.capabilities or {}
            )
            require('lspconfig')[server_name].setup(server_opts)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

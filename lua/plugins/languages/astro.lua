-- In lua/plugins/astro.lua

return {
  -- 1. Ensure the Treesitter parser for Astro is installed
  -- for correct syntax highlighting and code parsing.
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      -- Safely add 'astro' to the list of parsers to be installed.
      vim.list_extend(opts.ensure_installed, { 'astro' })
    end,
  },

  -- 2. Configure the 'astro' language server itself.
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- This is the robust way to add a server to a potentially
      -- existing lspconfig configuration.
      opts.servers = opts.servers or {}
      opts.servers.astro = {}
    end,
  },

  -- 3. Configure the formatter for .astro files.
  -- This assumes you use 'conform.nvim'.
  {
    'conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.astro = { 'prettier', 'prettierd' }
    end,
  },
}

-- In lua/plugins/languages/astro.lua
return {
  -- 1. Ensure the Treesitter parser for Astro is installed
  -- for correct syntax highlighting and code parsing.
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      -- Initialize opts if it's nil
      opts = opts or {}
      -- Initialize ensure_installed as empty table if it doesn't exist
      opts.ensure_installed = opts.ensure_installed or {}
      -- Safely add 'astro' to the list of parsers to be installed.
      vim.list_extend(opts.ensure_installed, { 'astro' })
      return opts
    end,
  },
  -- 2. Configure the 'astro' language server itself.
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- Initialize opts if it's nil
      opts = opts or {}
      -- This is the robust way to add a server to a potentially
      -- existing lspconfig configuration.
      opts.servers = opts.servers or {}
      opts.servers.astro = {}
      return opts
    end,
  },
  -- 3. Configure the formatter for .astro files.
  -- This assumes you use 'conform.nvim'.
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      -- Initialize opts if it's nil
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.astro = { 'prettier', 'prettierd' }
      return opts
    end,
  },
}

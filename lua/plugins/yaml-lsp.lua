return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.yamlls = vim.tbl_deep_extend("force", opts.servers.yamlls or {}, {
      -- FIXME: Neovim 0.11.5 LSP incremental sync crashes on YAML (sync.lua:195, prev_line nil).
      -- Validate: upgrade Neovim and remove this; if YAML files no longer trigger the error, keep it deleted.
      flags = {
        allow_incremental_sync = false,
      },
    })
  end,
}

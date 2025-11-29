return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      mode = "cursor", -- topmost context for cursor
      max_lines = 3, -- limit context height
      multiline_threshold = 1,
      trim_scope = "inner",
    },
  },
}

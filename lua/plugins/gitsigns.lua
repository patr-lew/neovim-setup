return {
  -- Re-enable gitsigns even though the mini-diff extra disables it.
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    opts = {
      -- Let mini.diff own the sign column; keep gitsigns for hunks/blame actions.
      signcolumn = false,
      numhl = false,
      linehl = false,
      word_diff = false,
      current_line_blame = true,
      current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
    },
  },
}

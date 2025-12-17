return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/angular-localize",
    name = "angular-localize",
    event = { "BufReadPost", "BufNewFile" },
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    opts = {
      enabled = true,
      filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
      replacement_text = "::",
      highlight_group = "Comment",
      message_highlight = "String", -- Highlight for message text
      debounce_ms = 50,
    },
    config = function(_, opts)
      require("angular-localize").setup(opts)
    end,
    keys = {
      {
        "<leader>uj",
        "<cmd>LocalizeToggle<cr>",
        desc = "Toggle $localize folding",
      },
    },
  },
}

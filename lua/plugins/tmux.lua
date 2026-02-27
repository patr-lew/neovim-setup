return {
  {
    "aserowy/tmux.nvim",
    keys = {
      { "<c-h>", "<cmd>lua require('tmux').move_left()<cr>", desc = "Tmux navigate left" },
      { "<c-j>", "<cmd>lua require('tmux').move_bottom()<cr>", desc = "Tmux navigate down" },
      { "<c-k>", "<cmd>lua require('tmux').move_top()<cr>", desc = "Tmux navigate up" },
      { "<c-l>", "<cmd>lua require('tmux').move_right()<cr>", desc = "Tmux navigate right" },
      {
        "<c-\\>",
        function()
          if not vim.env.TMUX then
            vim.notify("Not running inside tmux", vim.log.levels.WARN)
            return
          end
          local output = vim.fn.system({ "tmux", "select-pane", "-l" })
          if vim.v.shell_error ~= 0 then
            local msg = output ~= "" and output or "unknown tmux error"
            vim.notify("tmux previous-pane failed: " .. msg, vim.log.levels.ERROR)
          end
        end,
        desc = "Tmux navigate previous",
      },
    },
    config = function()
      return require("tmux").setup({
        navigation = {
          enable_default_keybindings = false,
        },
        resize = {
          enable_default_keybindings = true,
        },
      })
    end,
  },
}

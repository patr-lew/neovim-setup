return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      cli = {
        tools = {
          copilot = { cmd = { 'copilot', '--alt-screen' } },
        },
      },
      servers = {
        copilot = { enabled = false },
      },
    },
  },
  {
    'folke/sidekick.nvim',
    opts = {
      nes = {
        enabled = false,
      },
      copilot = {
        status = {
          enabled = false,
          level = vim.log.levels.OFF,
        },
      },
    },
    keys = {
      { '<leader>uN', false },
      { '<tab>', false, mode = 'n' },
    },
  },
}

return {
  {
    'zapling/mason-lock.nvim',
    dependencies = {
      'mason-org/mason.nvim',
    },
    config = function()
      require('mason-lock').setup()
    end,
  },
}

return {
  'shushtain/nvim-treesitter-incremental-selection',
  config = function()
    local tsis = require 'nvim-treesitter-incremental-selection'

    ---@type TSIS.Config
    tsis.setup {
      ignore_injections = false,
      loop_siblings = false,
      fallback = false,
      quiet = false,
    }
  end,
}

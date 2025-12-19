return {
  'nvim-telescope/telescope.nvim',
  keys = {
    {
      '<leader>r',
      function()
        local current_file = vim.fn.expand '%:t'
        local current_dir = vim.fn.expand '%:p:h'

        if current_file == '' then
          vim.notify('No active buffer', vim.log.levels.WARN)
          return
        end

        -- Extract base name (everything before first dot)
        local base_name = current_file:match '^([^%.]+)'

        if not base_name then
          vim.notify('Could not extract base name', vim.log.levels.WARN)
          return
        end

        -- Use telescope to find files with same base name
        require('telescope.builtin').find_files {
          prompt_title = 'Related Files: '
            .. base_name
            .. ' in '
            .. current_dir,
          cwd = current_dir,
          search_file = base_name,
        }
      end,
      desc = 'Find related files (same base name)',
    },
  },
}

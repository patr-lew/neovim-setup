return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'Avi-D-coder/whisper.nvim' },
    opts = function(_, opts)
      local ok, whisper = pcall(require, 'whisper')
      if not ok then
        return
      end

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      table.insert(opts.sections.lualine_x, 1, whisper.lualine_component)
    end,
  },
}

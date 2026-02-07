return {
  {
    'Avi-D-coder/whisper.nvim',
    config = function()
      require('whisper').setup {
        model = 'base.en',
        auto_download_model = false,
        keybind = '<C-a>',
        manual_trigger_key = '<Enter>',
        step_ms = 5000,
        length_ms = 8000,
        poll_interval_ms = 10001,
      }
    end,
    keys = {
      { '<C-a>', mode = { 'n', 'i', 'v' }, desc = 'Toggle speech-to-text' },
    },
  },
}

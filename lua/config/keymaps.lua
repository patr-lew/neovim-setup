-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('t', 'jk', [[<C-\><C-n>]]) -- exit terminal to normal
vim.keymap.set('n', '<leader>fs', '<cmd>w<cr>')

-- Navigate cursor position history (jumplist)
vim.keymap.set('n', '<C-,>', '<C-o>', { desc = 'Go to previous cursor position' })
vim.keymap.set('n', '<C-.>', '<C-i>', { desc = 'Go to next cursor position' })

vim.keymap.set('n', '<leader>gg', function()
  if not vim.env.TMUX then
    vim.notify('Not running inside tmux', vim.log.levels.WARN)
    return
  end

  -- Match the tmux prefix+g popup behavior and show errors if tmux rejects the command.
  local output = vim.fn.system({
    'tmux',
    'display-popup',
    '-E',
    '-w',
    '95%',
    '-h',
    '95%',
    '-x',
    'C',
    '-y',
    'C',
    '-b',
    'rounded',
    '-T',
    ' 󰊢 LazyGit ',
    '-s',
    'fg=brightwhite,bg=default',
    '-S',
    'fg=blue,bg=default',
    '-d',
    '#{pane_current_path}',
    'lazygit',
  })

  if vim.v.shell_error ~= 0 then
    local msg = output ~= '' and output or 'unknown tmux error'
    vim.notify('tmux popup failed: ' .. msg, vim.log.levels.ERROR)
  end
end, { desc = 'Lazygit (tmux popup)' })

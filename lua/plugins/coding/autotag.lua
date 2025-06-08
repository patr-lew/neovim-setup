return {
  'windwp/nvim-ts-autotag',
  ft = {
    'html',
    'javascriptreact',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
  },
  config = function()
    require('nvim-ts-autotag').setup()
  end,
}

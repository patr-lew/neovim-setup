-- Use LazyVim's global root detection override
-- This affects ALL LSP servers, not just Angular
return {
  'neovim/nvim-lspconfig',
  opts = function()
    -- Override LazyVim's root detection to prefer .git in Angular projects
    local root = require('lazyvim.util').root
    local util = require 'lspconfig.util'
    local monorepo_root = util.root_pattern(
      'nx.json',
      'angular.json',
      'workspace.json',
      'pnpm-workspace.yaml',
      'yarn.lock',
      'package-lock.json',
      '.git'
    )

    -- Add a named detector for Angular monorepo
    root.detectors.angular_monorepo = function(buf)
      local path = vim.api.nvim_buf_get_name(buf)
      local git_root = monorepo_root(path)

      -- Only override if we're in an Angular project
      if
        git_root
        and (
          vim.fn.filereadable(git_root .. '/angular.json') == 1
          or vim.fn.filereadable(git_root .. '/nx.json') == 1
        )
      then
        return { git_root }
      end

      return {}
    end

    -- Prepend our detector to the spec list so it runs first
    root.spec = vim.list_extend({ 'angular_monorepo' }, root.spec or {})

    require('lspconfig').tsserver.setup {
      root_dir = monorepo_root,
      single_file_support = false,
    }

    require('lspconfig').angularls.setup {
      root_dir = monorepo_root,
      single_file_support = false,
    }
  end,
}

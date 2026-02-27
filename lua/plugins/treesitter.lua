return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })

    local prev_disable = vim.tbl_get(opts, "highlight", "disable")
    opts.highlight = opts.highlight or {}
    opts.highlight.disable = function(lang, buf)
      if vim.bo[buf].filetype == "sshconfig" then
        return true
      end
      if type(prev_disable) == "function" then
        return prev_disable(lang, buf)
      end
      if type(prev_disable) == "table" then
        return vim.tbl_contains(prev_disable, lang)
      end
      return false
    end
  end,
}

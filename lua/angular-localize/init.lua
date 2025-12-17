local M = {}

local autocmds = require("angular-localize.autocmds")

M.config = {
  enabled = true,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  replacement_text = "::",
  highlight_group = "Comment",
  message_highlight = "String",
  debounce_ms = 50,
}

M.enabled_buffers = {}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  if M.config.enabled then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = M.config.filetypes,
      callback = function(args)
        M.enable(args.buf)
      end,
    })
  end

  vim.api.nvim_create_user_command("LocalizeEnable", function()
    M.enable()
  end, {})

  vim.api.nvim_create_user_command("LocalizeDisable", function()
    M.disable()
  end, {})

  vim.api.nvim_create_user_command("LocalizeToggle", function()
    M.toggle()
  end, {})

  vim.api.nvim_create_user_command("LocalizeReload", function()
    package.loaded["angular-localize"] = nil
    package.loaded["angular-localize.parser"] = nil
    package.loaded["angular-localize.extmarks"] = nil
    package.loaded["angular-localize.autocmds"] = nil

    for bufnr, _ in pairs(M.enabled_buffers) do
      M.disable(bufnr)
    end

    require("angular-localize").setup(M.config)
  end, {})
end

function M.enable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if M.enabled_buffers[bufnr] then
    return
  end
  M.enabled_buffers[bufnr] = true
  autocmds.setup_autocmds(bufnr, M.config)
end

function M.disable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not M.enabled_buffers[bufnr] then
    return
  end
  M.enabled_buffers[bufnr] = nil
  autocmds.clear_autocmds(bufnr)
end

function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if M.enabled_buffers[bufnr] then
    M.disable(bufnr)
  else
    M.enable(bufnr)
  end
end

return M

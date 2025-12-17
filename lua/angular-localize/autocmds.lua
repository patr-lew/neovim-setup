local M = {}

local parser = require("angular-localize.parser")
local extmarks = require("angular-localize.extmarks")

M.cache = {}
M.last_line = {}
M.timer = nil

function M.on_cursor_moved(bufnr, opts)
  if M.timer then
    M.timer:stop()
  end

  M.timer = vim.defer_fn(function()
    if vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor[1] - 1

    if M.last_line[bufnr] ~= current_line then
      if not M.cache[bufnr] then
        M.cache[bufnr] = parser.find_localize_lines(bufnr)
      end
      extmarks.refresh_buffer(bufnr, current_line, M.cache[bufnr], opts)
      M.last_line[bufnr] = current_line
    end
  end, opts.debounce_ms or 50)
end

function M.setup_autocmds(bufnr, opts)
  local group = vim.api.nvim_create_augroup("AngularLocalize_" .. bufnr, { clear = true })

  M.cache[bufnr] = parser.find_localize_lines(bufnr)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1] - 1
  M.last_line[bufnr] = current_line
  extmarks.refresh_buffer(bufnr, current_line, M.cache[bufnr], opts)

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      M.on_cursor_moved(bufnr, opts)
    end,
  })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      M.cache[bufnr] = nil
      M.on_cursor_moved(bufnr, opts)
    end,
  })

  vim.api.nvim_create_autocmd("BufUnload", {
    group = group,
    buffer = bufnr,
    callback = function()
      M.cache[bufnr] = nil
      M.last_line[bufnr] = nil
      if M.timer then
        M.timer:stop()
        M.timer = nil
      end
    end,
  })
end

function M.clear_autocmds(bufnr)
  vim.api.nvim_clear_autocmds({ group = "AngularLocalize_" .. bufnr })
  extmarks.clear_buffer(bufnr)
  M.cache[bufnr] = nil
  M.last_line[bufnr] = nil
end

return M

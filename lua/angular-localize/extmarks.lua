local M = {}

M.ns = vim.api.nvim_create_namespace("angular_localize")

function M.collapse_line(bufnr, line, start_col, end_col, opts)
  opts = opts or {}
  M.expand_line(bufnr, line)

  local line_text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
  if not line_text then
    return
  end

  local after_context = line_text:sub(end_col + 1)
  local backtick_pos = after_context:find("`")
  if not backtick_pos then
    return
  end

  local message_text = after_context:sub(1, backtick_pos - 1)
  local after_backtick = after_context:sub(backtick_pos)
  local replacement_text = opts.replacement_text or "::"
  local padding_length = math.max(0, #line_text - start_col - #replacement_text - #message_text - #after_backtick)

  local virt_text = {
    { replacement_text, opts.highlight_group or "Comment" },
  }

  if #message_text > 0 then
    table.insert(virt_text, { message_text, opts.message_highlight or "String" })
  end

  if #after_backtick > 0 then
    table.insert(virt_text, { after_backtick, opts.message_highlight or "String" })
  end

  if padding_length > 0 then
    table.insert(virt_text, { string.rep(" ", padding_length), "Normal" })
  end

  vim.api.nvim_buf_set_extmark(bufnr, M.ns, line, start_col, {
    end_col = #line_text,
    virt_text = virt_text,
    virt_text_pos = "overlay",
    hl_mode = "combine",
  })
end

function M.expand_line(bufnr, line)
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, M.ns, { line, 0 }, { line, -1 }, {})
  for _, extmark in ipairs(extmarks) do
    vim.api.nvim_buf_del_extmark(bufnr, M.ns, extmark[1])
  end
end

function M.refresh_buffer(bufnr, current_line, matches, opts)
  for _, match in ipairs(matches) do
    if match.line ~= current_line then
      M.collapse_line(bufnr, match.line, match.start_col, match.end_col, opts)
    else
      M.expand_line(bufnr, match.line)
    end
  end
end

function M.clear_buffer(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)
end

return M

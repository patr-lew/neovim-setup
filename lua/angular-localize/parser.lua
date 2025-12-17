local M = {}

local LOCALIZE_PATTERN = '%$localize%s*`'

function M.parse_context(line_text)
  local localize_start = line_text:find(LOCALIZE_PATTERN)
  if not localize_start then
    return nil
  end

  local backtick_pos = line_text:find('`', localize_start)
  if not backtick_pos then
    return nil
  end

  local after_backtick = line_text:sub(backtick_pos + 1)
  local context_match = after_backtick:match '^(:([^:]+):)'

  if not context_match or context_match == '::' then
    return nil
  end

  local start_col = backtick_pos
  local end_col = backtick_pos + #context_match

  return start_col, end_col, context_match
end

function M.find_localize_lines(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local matches = {}

  for line_num, line_text in ipairs(lines) do
    local start_col, end_col, context = M.parse_context(line_text)
    if start_col then
      table.insert(matches, {
        line = line_num - 1,
        start_col = start_col,
        end_col = end_col,
        context = context,
      })
    end
  end

  return matches
end

return M

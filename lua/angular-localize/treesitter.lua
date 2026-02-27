local M = {}

-- Cache for Treesitter highlight chunks to avoid re-parsing
M.highlight_cache = {}

-- Recursively extract syntax-highlighted chunks from a node and its children
local function extract_node_chunks(
  node,
  bufnr,
  line,
  start_col,
  end_col,
  lang,
  result
)
  local node_start_row, node_start_col, node_end_row, node_end_col =
    node:range()

  -- Only process nodes on our target line
  if node_start_row ~= line or node_end_row ~= line then
    -- Still recurse into children in case they're on the target line
    for child in node:iter_children() do
      extract_node_chunks(child, bufnr, line, start_col, end_col, lang, result)
    end
    return
  end

  -- If node is completely outside our range, skip it and its children
  if node_end_col <= start_col or node_start_col >= end_col then
    return
  end

  -- Get node type for highlight mapping
  local node_type = node:type()

  -- Check if node has children
  local child_count = node:child_count()

  if child_count == 0 then
    -- Leaf node: extract text and determine highlight
    local node_text_start = math.max(node_start_col, start_col)
    local node_text_end = math.min(node_end_col, end_col)

    if node_text_end > node_text_start then
      local line_text =
        vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
      if line_text then
        local text = line_text:sub(node_text_start + 1, node_text_end)

        -- Map node type to highlight group
        local hl_group = M.get_highlight_for_node_type(node_type, lang)

        table.insert(result, {
          start_col = node_text_start,
          end_col = node_text_end,
          text = text,
          hl_group = hl_group,
        })
      end
    end
  else
    -- Parent node: recurse into children
    for child in node:iter_children() do
      extract_node_chunks(child, bufnr, line, start_col, end_col, lang, result)
    end
  end
end

-- Map Treesitter node types to highlight groups
function M.get_highlight_for_node_type(node_type, lang)
  -- Common mappings for TypeScript/JavaScript
  local type_map = {
    -- Template string components
    ['string_fragment'] = '@string',
    ['template_substitution'] = '@none', -- Container, use children
    ['${'] = '@punctuation.special',
    ['}'] = '@punctuation.special',
    ['`'] = '@punctuation.delimiter',

    -- Identifiers and keywords
    ['identifier'] = '@variable',
    ['property_identifier'] = '@property',

    -- Operators and punctuation
    [':'] = '@punctuation.delimiter',
    ['@'] = '@punctuation.special',
    [';'] = '@punctuation.delimiter',
    ['='] = '@operator',

    -- Fallback for other types
  }

  local hl = type_map[node_type]
  if hl then
    return hl
  end

  -- For unmapped types, try to construct a valid highlight group name
  -- Only use alphanumeric characters and underscores in the node type part
  if node_type:match '^[a-zA-Z0-9_]+$' then
    return '@' .. node_type .. '.' .. lang
  end

  -- Fallback to generic string highlight for special characters
  return 'String'
end

-- Extract syntax-highlighted chunks from a text range using Treesitter
-- Returns array of {text, highlight_group} tuples
function M.get_highlight_chunks(bufnr, line, start_col, end_col)
  -- Create cache key
  local cache_key =
    string.format('%d:%d:%d:%d', bufnr, line, start_col, end_col)

  -- Check cache first
  if M.highlight_cache[cache_key] then
    return M.highlight_cache[cache_key]
  end

  -- Try to get parser for the buffer
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if not lang then
    return nil
  end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok or not parser then
    return nil
  end

  -- Parse the buffer
  local trees = parser:parse()
  if not trees or #trees == 0 then
    return nil
  end

  local tree = trees[1]
  local root = tree:root()

  -- Get line text
  local line_text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
  if not line_text then
    return nil
  end

  -- Extract the relevant text portion
  local text_portion = line_text:sub(start_col + 1, end_col)
  if #text_portion == 0 then
    return nil
  end

  -- Recursively extract chunks from tree nodes
  local raw_chunks = {}
  extract_node_chunks(root, bufnr, line, start_col, end_col, lang, raw_chunks)

  -- If no chunks found, return nil to trigger fallback
  if #raw_chunks == 0 then
    return nil
  end

  -- Sort chunks by start position
  table.sort(raw_chunks, function(a, b)
    return a.start_col < b.start_col
  end)

  -- Build final chunks array, filling gaps with default String highlight
  local chunks = {}
  local pos = start_col

  for _, chunk in ipairs(raw_chunks) do
    -- Add gap before this chunk
    if chunk.start_col > pos then
      local gap_text = line_text:sub(pos + 1, chunk.start_col)
      if #gap_text > 0 then
        table.insert(chunks, { gap_text, 'String' })
      end
    end

    -- Add the chunk
    table.insert(chunks, { chunk.text, chunk.hl_group })
    pos = chunk.end_col
  end

  -- Add any remaining text
  if pos < end_col then
    local remaining = line_text:sub(pos + 1, end_col)
    if #remaining > 0 then
      table.insert(chunks, { remaining, 'String' })
    end
  end

  -- Cache the result
  M.highlight_cache[cache_key] = chunks

  return chunks
end

-- Clear cache for a buffer (called when buffer changes)
function M.clear_cache(bufnr)
  for key in pairs(M.highlight_cache) do
    if key:match('^' .. bufnr .. ':') then
      M.highlight_cache[key] = nil
    end
  end
end

return M

# Angular $localize Context Folding Plugin

A Neovim plugin that automatically collapses the i18n context portion in Angular `$localize` template strings for improved readability.

## Features

- **Automatic Context Collapsing**: Hides verbose i18n context (e.g., `:Help/Hint Texts@@material.material-instance.delete.message.existing-reference:`) and shows `::` instead
- **Cursor-Aware**: Automatically expands to show full context when cursor is on the line
- **Visual Feedback**: Collapsed context is shown in dimmed color (Comment highlight group)
- **Performance Optimized**: Debounced cursor tracking and intelligent caching
- **Language Support**: Works with TypeScript, JavaScript, TSX, and JSX files

## Example

**Before (cursor on different line):**
```typescript
const error = $localize`::Entity could not be deleted...`;
//                      ^^ dimmed/grayed out
```

**After (cursor on the line):**
```typescript
const error = $localize`:Help/Hint Texts@@material.material-instance.delete.message.existing-reference:Entity could not be deleted...`;
//                      ^^^^^^^^^^ full context visible
```

## Installation

The plugin is already installed in this configuration. It uses a local directory structure.

## Configuration

Default configuration (in `lua/plugins/angular-localize.lua`):

```lua
{
  enabled = true,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  replacement_text = "::",           -- What to show when collapsed
  highlight_group = "Comment",       -- Highlight for collapsed text
  debounce_ms = 50,                  -- Cursor movement debounce
}
```

## Commands

- `:LocalizeEnable` - Enable context folding for current buffer
- `:LocalizeDisable` - Disable context folding for current buffer
- `:LocalizeToggle` - Toggle context folding for current buffer

## Keybindings

- `<leader>tL` - Toggle $localize context folding

## How It Works

1. **Pattern Detection**: Scans TypeScript/JavaScript files for `$localize` template strings with context patterns (`:context@@id:`)
2. **Virtual Text Overlay**: Uses Neovim's extmarks API to overlay collapsed text without modifying the actual file
3. **Cursor Tracking**: Monitors cursor position and automatically expands/collapses based on current line
4. **Smart Caching**: Caches parsed patterns and only re-parses when buffer content changes

## Testing

A test file is included at `test-localize.ts` with various `$localize` examples. Open it in Neovim and move your cursor between lines to see the plugin in action.

## Technical Details

- Uses Neovim's extmarks API with `virt_text_pos = 'overlay'`
- Implements debounced cursor tracking to minimize performance impact
- Pattern matching: `^:([^:]*@@[^:]*):` within template literals
- Buffer-local autocommands prevent cross-buffer interference

## Limitations

- Currently supports single-line template strings only
- Requires Neovim 0.10+ for extmark overlay support
- Pattern must follow Angular i18n format: `:context@@id:message`

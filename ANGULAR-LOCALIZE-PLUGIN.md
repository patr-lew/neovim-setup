# Angular $localize Context Folding Plugin - Testing & Troubleshooting

## Plugin Created ✅

The plugin has been successfully created with the following structure:

```
lua/
├── angular-localize/
│   ├── init.lua           # Main module with setup/enable/disable/toggle
│   ├── parser.lua         # Pattern detection (supports both :context: and :context@@id:)
│   ├── extmarks.lua       # Virtual text overlay management
│   ├── treesitter.lua     # Treesitter-based syntax highlighting (NEW)
│   ├── autocmds.lua       # Cursor tracking with debug mode
│   └── README.md          # Documentation
└── plugins/
    └── angular-localize.lua  # LazyVim plugin spec
```

## How it Works

The plugin uses Neovim's extmark overlay feature to:
1. **Detect** `$localize` patterns with context (`:context:` or `:context@@id:`)
2. **Hide** the verbose context by overlaying it with `::`
3. **Preserve** the message text with **Treesitter-based syntax highlighting** (NEW)
4. **Expand** automatically when cursor enters the line
5. **Collapse** when cursor leaves the line

### Visual Result
```typescript
// Cursor on different line (collapsed with Treesitter highlighting):
const error = $localize`::An unexpected error occurred.                  `;
//                      ^^ dimmed   ^^^^^^^^^^^^^^^^^^^ string color

// With string interpolation (NEW - preserves syntax colors):
const msg = $localize`::Message: ${variable}:name: done`;
//                    ^^ dimmed  ^^^^^^^^^^ string  
//                                 ^^       punctuation
//                                   variable  identifier
//                                         ^^       punctuation
//                                           ^^^^^^ string

// Cursor on this line (expanded):
const error = $localize`:Help/Hint Texts@@error.base-error-code:An unexpected error occurred.`;
//                      ^^^^^^^^^^^^^^^^ full context visible
```

## How to Use

### 1. Restart Neovim
The plugin will auto-activate on TypeScript/JavaScript files.

### 2. Or Manually Reload
```vim
:LocalizeReload
```

### 3. Test with the Test File
```bash
nvim test-angular.ts
```

### 4. Toggle Plugin
```vim
:LocalizeToggle
" Or use keybinding:
<leader>uj
```

## Expected Behavior

When cursor is NOT on a line with `$localize`:
```typescript
const error = $localize`::An unexpected error occurred.                  `;
//                      ^^ dimmed (Comment highlight)
//                        ^^^^^^^^^^^^^^^^^^ string color
//                                                                        ^ preserved
```

When cursor IS on the line:
```typescript
const error = $localize`:Help/Hint Texts@@error.base-error-code.UnexpectedError.message:An unexpected error occurred.`;
//                      ^^^^^^^^^^^^^^^^^ full context visible
```

### What Gets Overlaid:
- **Context**: `:Help/Hint Texts@@error:` → `::` (dimmed)
- **Message**: Preserved with String highlight
- **Closing**: Backtick `` ` `` and trailing `;` or `,` preserved
- **Padding**: Spaces fill the gap (invisible)

## Configuration

Edit `lua/plugins/angular-localize.lua`:

```lua
opts = {
  enabled = true,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  replacement_text = "::",           -- Text shown instead of context
  highlight_group = "Comment",       -- Highlight for :: (dimmed)
  message_highlight = "String",      -- Fallback highlight for message text
  use_treesitter_highlights = true,  -- NEW: Use Treesitter for granular syntax highlighting
  debounce_ms = 50,                  -- Cursor movement debounce
  debug = false,                     -- Enable debug logging
},
```

### Treesitter Highlighting (NEW)

When `use_treesitter_highlights = true` (default), the plugin uses Neovim's Treesitter to provide granular syntax highlighting for the collapsed message text. This preserves:

- **String interpolations**: `${variable}` with distinct colors for `${`, variable name, and `}`
- **Template expressions**: Proper highlighting of embedded expressions
- **Punctuation**: Colons, backticks, and other delimiters maintain their syntax colors

**Requirements**:
- Treesitter parser installed for TypeScript/JavaScript (`TSInstall typescript javascript`)
- If Treesitter is unavailable or fails, automatically falls back to simple `message_highlight`

**Benefits**:
- String interpolations like `${test}:test:` show multi-color highlighting instead of flat green
- Better visual distinction of code elements within collapsed messages
- Maintains editor's color scheme consistency

**Disable Treesitter**:
```lua
opts = {
  use_treesitter_highlights = false,  -- Use simple String highlight instead
}
```

### Highlight Options

**For `replacement_text` (`::`)**:
- `"Comment"` - Dimmed/grayed out (default)
- `"NonText"` - Very subtle
- `"SpecialKey"` - Visible but distinct

**For `message_highlight`** (fallback when Treesitter disabled/unavailable):
- `"String"` - Matches template literal color (default, recommended)
- `"Normal"` - Regular text color
- `"@string"` - Treesitter string highlight
- Any custom highlight group

**Treesitter Highlight Groups** (automatic when enabled):
- `@string` - String fragments
- `@punctuation.special` - `${`, `}`
- `@punctuation.delimiter` - `:`, `;`, `` ` ``
- `@variable` - Identifiers in interpolations
- And more based on syntax tree

## Troubleshooting

### Issue: Not activating

**Check if loaded:**
```vim
:lua print(vim.inspect(require("angular-localize").enabled_buffers))
```

**Manually enable:**
```vim
:LocalizeEnable
```

**Force reload:**
```vim
:LocalizeReload
```

### Issue: Want to see debug info

**Enable debug mode:**
```vim
:lua require("angular-localize").config.debug = true
:LocalizeReload
```

### Issue: Seeing duplicate text or gaps

This was fixed! Make sure you've run `:LocalizeReload` after the latest update.

The plugin now:
- Covers the entire region (context + message)
- Adds trailing spaces to fill any gaps
- No text duplication

## Supported Patterns

✅ `:context:message` - Simple context  
✅ `:context@@id:message` - Full Angular i18n format  
✅ `:@@id:message` - ID only  
✅ Template string interpolations: `${var}:name:`  
✅ Long contexts with special characters  
❌ `::message` - Already collapsed (ignored)  
❌ `message` - No context (ignored)  

## Commands

- `:LocalizeEnable` - Enable for current buffer
- `:LocalizeDisable` - Disable for current buffer
- `:LocalizeToggle` - Toggle for current buffer  
- `:LocalizeReload` - Reload plugin (clears cache, reloads all modules)

## Known Working Test Cases

```typescript
// These should all collapse correctly:
const a = $localize`:Q-MES:text`;
const b = $localize`:Help:message`;
const c = $localize`:Category@@id:message`;
const d = $localize`:@@just-id:message`;
const e = $localize`:Help/Hint Texts@@error.base-error-code.UnexpectedError.message:An unexpected error occurred.`;

// These should NOT be affected:
const f = $localize`::already collapsed`;
const g = $localize`no context`;
```

## Performance

- **Efficient**: Uses extmarks (no buffer modifications)
- **Debounced**: 50ms delay on cursor movement
- **Cached**: Parses patterns once per buffer edit
- **Lazy**: Only active on TypeScript/JavaScript files

## Next Steps

1. **Run** `:LocalizeReload` to load the latest version
2. **Open** any TypeScript file with `$localize`
3. **Move** cursor between lines to see the effect
4. **Customize** highlights in the config if desired

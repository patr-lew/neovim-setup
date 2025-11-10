# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on top of LazyVim, a Neovim starter template. The configuration uses lazy.nvim as the plugin manager and follows LazyVim's structured approach to plugin organization.

## Architecture

### Core Structure

- **init.lua**: Entry point that bootstraps lazy.nvim and loads the config module
- **lua/config/**: Core configuration directory
  - `lazy.lua`: Lazy.nvim setup with plugin spec imports
  - `options.lua`: Editor options (extends LazyVim defaults)
  - `keymaps.lua`: Custom keybindings (extends LazyVim defaults)
  - `autocmds.lua`: Autocommands (extends LazyVim defaults)
- **lua/plugins/**: Custom plugin configurations that override or extend LazyVim
- **lazyvim.json**: LazyVim extras configuration tracking installed extras

### Plugin System

The configuration uses a layered approach:
1. LazyVim provides the base plugin configuration
2. LazyVim extras add additional language/feature support (tracked in lazyvim.json)
3. Custom plugins in lua/plugins/ override or extend the defaults

Plugin files return a table/array of plugin specs. Each spec can include:
- Plugin URL/name
- Dependencies
- Configuration options (`opts` table)
- Custom setup (`config` function)
- Keybindings (`keys` table)
- Events/commands for lazy-loading

### Language Support

**Go**: Uses ray-x/go.nvim with automatic goimports on save (lua/plugins/languages/go.lua). The BufWritePre autocommand formats Go files with goimports before saving.

**Installed LazyVim Extras** (from lazyvim.json):
- nvim-cmp for completion
- DAP core and nlua adapters
- aerial for symbol navigation
- dial for enhanced increment/decrement
- Docker, Go, JSON, and Markdown language support

### Testing Framework

**Neotest** (lua/plugins/test.lua) is the core testing framework with these adapters:
- neotest-golang (requires gotestsum binary)
- neotest-vitest for JavaScript/TypeScript
- neotest-pest for PHP
- neotest-plenary for Neovim Lua plugins

Key integration: Neotest is integrated with Overseer (task runner) and Trouble (diagnostics). Tests automatically refresh Trouble and close it if all tests pass.

**Key Test Commands**:
- `<leader>tt`: Run current file
- `<leader>tr`: Run nearest test
- `<leader>tl`: Run last test
- `<leader>ts`: Toggle test summary
- `<leader>td`: Debug nearest test with DAP

### Task Management

**Overseer** (lua/plugins/overseer.lua) provides task running capabilities:
- `<leader>ot`: Toggle task list
- `<leader>or`: Run task
- `<leader>ol`: Run custom command
- `<leader>oq`: Quick action
- `<leader>oa`: Task actions
- Task list opens at bottom with custom keybindings (H/L for detail, PageUp/PageDown for scrolling)

### Editor Integration

**TMUX Integration**: Uses both aserowy/tmux.nvim and christoomey/vim-tmux-navigator for seamless navigation between Neovim and tmux panes with Ctrl+hjkl.

**Colorscheme**: Tokyo Night with automatic dark/light mode switching via cormacrelf/dark-notify. The plugin monitors macOS system theme changes and switches between tokyonight-storm (dark) and tokyonight-day (light) automatically.

**Which-key**: Configured with helix preset and zero delay. Key group leaders:
- `<leader>a`: AI tools
- `<leader>b`: Buffer management
- `<leader>c`: Code actions
- `<leader>d`: Debug
- `<leader>f`: Find/Files
- `<leader>g`: Git (with subgroups for blame, diff, hunks)
- `<leader>o`: Overseer tasks
- `<leader>s`: Search
- `<leader>t`: Tests

**Bufferline**: Explicitly disabled (lua/plugins/bufferline.lua)

### Custom Keybindings

Global custom keybindings (lua/config/keymaps.lua):
- `jk` in insert mode: Escape to normal mode
- `<leader>fs`: Save current file
- `gr`: Telescope LSP references (via lua/plugins/telescope.lua)

## Development Workflow

### Plugin Development

When adding or modifying plugins:
1. Create/edit files in lua/plugins/ or lua/plugins/[category]/
2. Plugin files should return a table with plugin specifications
3. Use `opts` table for simple configuration or `config` function for complex setup
4. LazyVim defaults are available at https://github.com/LazyVim/LazyVim

### Testing Workflow

The testing setup expects:
- Go tests work out of the box with neotest-golang (ensure gotestsum is installed)
- JavaScript/TypeScript tests use Vitest
- PHP tests use Pest
- Tests integrate with Overseer for background task management
- Failed tests automatically open in Trouble quickfix window

### Formatting and LSP

- Go files: Automatic goimports on save via BufWritePre autocmd
- LSP configurations inherit from LazyVim extras
- Conform.nvim and other formatters may be configured via LazyVim extras

### Performance

The configuration disables several unused RTP plugins (gzip, tarPlugin, tohtml, tutor, zipPlugin) for faster startup.

#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[nvim-update] %s\n' "$*"
}

log "Updating plugins"
nvim --headless "+Lazy! sync" "+qa"

log "Rebuilding Treesitter parsers"
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
nvim --headless "+Lazy! load nvim-treesitter" "+lua require('nvim-treesitter.install').install('all',{force=true,summary=true}):wait()" "+qa"

log "Running Treesitter healthcheck"
nvim --headless "+Lazy! load nvim-treesitter" "+checkhealth nvim-treesitter" "+qa"

log "Done"

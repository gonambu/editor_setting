# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration repository with a Lua-based setup using Packer.nvim as the plugin manager. The configuration is structured with modular Lua files for different aspects of the editor setup.

## Architecture

- **nvim/init.lua**: Main configuration entry point that loads plugins via Packer, sets up LSP, completion, and imports modular configuration files
- **nvim/lua/**: Contains modular configuration files:
  - `disable_default_plugin.lua`: Disables unwanted default Neovim plugins for performance
  - `keymaps.lua`: Custom key mappings including Telescope shortcuts and window navigation
  - `options.lua`: Vim options and settings

## Key Components

### Plugin Management
- Uses Lazy.nvim for plugin management
- Plugins are lazy-loaded using events, keys, and commands
- Plugin configurations are defined inline within the Lazy setup
- Auto-installs Lazy.nvim if not present

### LSP Setup
- Mason.nvim for LSP server management
- Configured LSP servers: lua_ls, tsserver
- Auto-formatting on save via none-ls (formerly null-ls)
- Linting: eslint_d, ktlint
- Formatting: prettier

### Key Features
- File explorer: Fern.vim (toggle with `<Leader>n`)
- Fuzzy finder: Telescope.nvim with custom mappings
- Completion: nvim-cmp with multiple sources
- Git integration: gitsigns.nvim
- Theme: gruvbox
- Auto-pairs, commentary, and surround functionality

### Key Mappings
- Leader key: Space
- File finder: `<Space><Space>f`
- Buffer switcher: `<Space><Space>b`
- Live grep: `<Leader>g`
- Tab management: `<Space>t` (new), `<Space>h/l` (navigate)
- LSP: `<Leader>df` (definition in new tab), `<Leader>v` (hover), `<Leader>rn` (rename)

## Development Commands

This repository contains only configuration files, so there are no build, test, or lint commands to run. Changes can be tested by:

1. Reloading Neovim configuration: `:source %` or restart Neovim
2. Installing/updating plugins: `:Lazy` to open Lazy interface, `:Lazy sync` to sync plugins
3. LSP server management: `:Mason` to open Mason interface

## File Structure

- Main configuration files are in `nvim/` directory
- Lua modules are organized in `nvim/lua/` subdirectory
- Plugin-specific configurations are embedded in `init.lua`
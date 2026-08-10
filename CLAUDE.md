# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Neovim configuration written in Lua, managed by lazy.nvim. Requires Neovim >= 0.12 and the
`tree-sitter` CLI (`brew install tree-sitter-cli`).

Install by symlinking `nvim/` to `~/.config/nvim`.

## Architecture

- `nvim/init.lua`: entry point. Sets leader, loads core modules, bootstraps lazy.nvim, imports `lua/plugins/`
- `nvim/lua/options.lua`: vim options
- `nvim/lua/keymaps.lua`: global key mappings
- `nvim/lua/disable_default_plugin.lua`: disables bundled plugins for startup time
- `nvim/lua/lsp.lua`: per-server settings via `vim.lsp.config()`, diagnostics, `LspAttach` key mappings
- `nvim/lua/plugins/*.lua`: one file per concern, each returning a lazy.nvim spec list

## Conventions

- LSP servers are configured with `vim.lsp.config()` and enabled by mason-lspconfig's `automatic_enable`.
  Do not use `require('lspconfig').<server>.setup{}` — the framework was removed in nvim-lspconfig v3.
- nvim-treesitter is pinned to the `main` branch. It has no `ensure_installed` or `highlight` options;
  parsers are installed with `require('nvim-treesitter').install()` and highlighting starts from a
  `FileType` autocmd.
- Formatting is conform.nvim, linting is nvim-lint. Do not reintroduce none-ls.
- Plugin `keys` specs must not collide with mappings in `keymaps.lua`, which is loaded before lazy.nvim.

## Key Components

| Concern | Plugin |
|---|---|
| Plugin manager | lazy.nvim |
| Colorscheme | tokyonight |
| Completion | blink.cmp |
| Fuzzy finder | fzf-lua |
| LSP install | mason.nvim + mason-lspconfig.nvim |
| Format / lint | conform.nvim + nvim-lint (prettier, ktlint, eslint_d) |
| Syntax | nvim-treesitter (`main`) |
| File explorer | oil.nvim |
| Statusline / bufferline | lualine.nvim, bufferline.nvim |
| Git | gitsigns.nvim |
| AI | claudecode.nvim |

LSP servers: `lua_ls`, `ts_ls`, `terraformls`, `rust_analyzer`.

## Key Mappings

Leader is `<Space>`.

| Mapping | Action |
|---|---|
| `<Space><Space>f` | Find files |
| `<Space><Space>b` | Buffers |
| `<Leader>g` | Live grep |
| `<Leader>n` | Toggle oil (float) |
| `<Space>h` / `<Space>l` | Prev / next buffer |
| `<Space>x` / `<Space>X` | Close buffer / other buffers |
| `<Leader>df` | Go to definition (new tab if another file) |
| `<Leader>v` | Hover |
| `<Leader>rn` | Rename |
| `<Leader>ca` | Code action |
| `<Leader>rf` | References |
| `<Leader>fmt` | Format buffer |
| `<Leader>ac` / `<C-,>` | Toggle Claude Code |

## Development Commands

Configuration only; there is nothing to build or test. Verify changes by:

1. Restarting Neovim, or `:source %` for standalone modules
2. `:Lazy sync` to install/update plugins, `:Lazy profile` to inspect startup cost
3. `:Mason` to manage servers and tools, `:checkhealth vim.lsp` to inspect LSP state
4. `:TSUpdate` to update treesitter parsers

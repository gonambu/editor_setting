vim.g.mapleader = " "

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
      'lambdalisue/fern.vim',
      opt = true,
      keys = {{"n", "<Leader>n"}},
      config = function()
          vim.api.nvim_set_keymap("n", "<Leader>n", ":Fern . -drawer -toggle<CR>", {noremap=true, silent=true})
          vim.g["fern#default_hidden"]=1
          vim.cmd [[Fern . -drawer -toggle<CR>]]
      end
  }
  use 'machakann/vim-sandwich'
  use 'tpope/vim-commentary'
  use { "ellisonleao/gruvbox.nvim" }
  use { "L3MON4D3/LuaSnip" }
  use {
      "hrsh7th/nvim-cmp",
      requires = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "saadparwaiz1/cmp_luasnip",
      }
  }
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }
  use {
      'tyru/open-browser.vim',
      config = function()
          vim.api.nvim_set_keymap("n", "<Leader>b", "<Plug>(openbrowser-smart-search)", {})
          vim.api.nvim_set_keymap("x", "<Leader>b", "<Plug>(openbrowser-smart-search)", {})
      end
  }
  use {
      'tyru/open-browser-github.vim',
      opt = true,
      cmd = "OpenGithubFile",
      requires = {{'tyru/open-browser.vim'}},
      after = 'open-browser.vim'
  }
  use {
      'nvim-lualine/lualine.nvim',
      config = function()
          require('lualine').setup({
              options = {
                  theme = 'gruvbox'
              }
          })
      end
  }
  use 'glidenote/memolist.vim'
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function ()
          local null_ls = require("null-ls")
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          null_ls.setup({
              sources = {
                  null_ls.builtins.diagnostics.eslint.with({
                      prefer_local = "node_modules/.bin", --プロジェクトローカルがある場合はそれを利用
                  }),
                  null_ls.builtins.formatting.prettier,
              },
              on_attach = function(client, bufnr)
                  if client.supports_method("textDocument/formatting") then
                      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                      vim.api.nvim_create_autocmd("BufWritePre", {
                          group = augroup,
                          buffer = bufnr,
                          callback = function()
                              vim.lsp.buf.format({bufnr = bufnr})
                          end,
                      })
                  end
              end,
          })
      end
  })
  use {
      "nvim-telescope/telescope.nvim", tag = '0.1.1',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function()
          local actions = require("telescope.actions")
          require('telescope').setup{
              defaults = {
                  path_display = { truncate = 3 },
                  mappings = {
                      i = {
                          ["<esc>"] = actions.close
                      },
                  },
                  file_ignore_patterns = { "node_modules" }
              },
              pickers = {
              },
              extensions = {
              }
          }
      end
  }
  use {'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    opt = true,
    event = {"BufRead"},
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {},
        highlight = { enable = true }
      }
    end
  }
  use({
      "folke/noice.nvim",
      config = function()
          require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
            messages = {
            }
          })
      end,
      requires = {
          "MunifTanjim/nui.nvim",
          "rcarriga/nvim-notify",
      }
  })
  use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
  }
end)

require("mason").setup()
require("mason-lspconfig").setup()

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require'luasnip'.lsp_expand(args.body)
        end
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'path'},
        {name = 'buffer'},
        {name = 'cmdline'},
        {name = 'luasnip'},
    },
    mapping = cmp.mapping.preset.insert({
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = capabilities,
    }
  end,
  ["lua_ls"] = function ()
      lspconfig.lua_ls.setup {
          settings = {
              Lua = {
                  diagnostics = {
                      globals = { "vim" }
                  }
              }
          }
      }
  end,
  ["tsserver"] = function ()
      lspconfig.tsserver.setup {
          on_attach = function (client, bufnr)
              client.server_capabilities.documentFormattingProvider = false
          end
      }
  end
}

local bufopts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>df', function ()
    vim.lsp.buf.definition()
    vim.api.nvim_command('tabnew')
end, bufopts)
vim.keymap.set('n', '<Leader>v', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<Leader>fmt', function() vim.lsp.buf.format { async = true } end, bufopts)

vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

require("disable_default_plugin")
require("keymaps")
require("options")

vim.api.nvim_create_user_command("FilePath", ":echo expand('%')", { nargs = 0 })

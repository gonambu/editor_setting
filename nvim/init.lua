vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'lambdalisue/fern.vim',
    keys = {
      { "<Leader>n", ":Fern . -drawer -toggle<CR>", desc = "Toggle Fern file explorer" }
    },
    config = function()
      vim.g["fern#default_hidden"] = 1
    end
  },

  'machakann/vim-sandwich',
  'tpope/vim-commentary',

  {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
          { 'tpope/vim-dadbod', lazy = true },
          { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
      },
      cmd = {
          'DBUI',
          'DBUIToggle',
          'DBUIAddConnection',
          'DBUIFindBuffer',
      },
      init = function()
          -- Your DBUI configuration
          vim.g.db_ui_use_nerd_fonts = 1
      end,
  },

  {
      "greggh/claude-code.nvim",
      dependencies = {
          "nvim-lua/plenary.nvim", -- Required for git operations
      },
      config = function()
          require("claude-code").setup()
      end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  { "L3MON4D3/LuaSnip" },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
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
    end
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver" },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
              capabilities = require('cmp_nvim_lsp').default_capabilities()
            })
          end,

          ["lua_ls"] = function ()
            require('lspconfig').lua_ls.setup {
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
            require('lspconfig').tsserver.setup {
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              on_attach = function (client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
              end
            }
          end
        }
      })
    end
  },

  "neovim/nvim-lspconfig",

  {
    'tyru/open-browser.vim',
    keys = {
      { "<Leader>b", "<Plug>(openbrowser-smart-search)", mode = {"n", "x"}, desc = "Open browser search" }
    }
  },

  {
    'tyru/open-browser-github.vim',
    cmd = "OpenGithubFile",
    dependencies = { 'tyru/open-browser.vim' }
  },

  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox'
        }
      })
    end
  },

  'glidenote/memolist.vim',

  {
    "nvimtools/none-ls.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim"
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        debug = true,
        sources = {
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.ktlint,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = true, bufnr = bufnr, timeout_ms = 5000 })
              end,
            })
          end
        end,
      })
    end
  },

  {
    "nvim-telescope/telescope.nvim", 
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
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
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {},
        highlight = { enable = true }
      }
    end
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        messages = {
        }
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() 
      require("nvim-autopairs").setup {} 
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('gitsigns').setup()
    end
  }
})

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

require("disable_default_plugin")
require("keymaps")
require("options")

vim.api.nvim_create_user_command("FilePath", ":echo expand('%')", { nargs = 0 })

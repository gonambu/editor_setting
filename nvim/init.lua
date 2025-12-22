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
          require("claude-code").setup({
              window = {
                  position = "vertical",
                  split_ratio = 0.3,
              }
          })
      end
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        performance = {
          debounce = 60,
          throttle = 30,
          max_view_entries = 200,
        },
        snippet = {
          expand = function(args)
            require'luasnip'.lsp_expand(args.body)
          end
        },
        sources = cmp.config.sources({
          {name = 'nvim_lsp'},
          {name = 'luasnip'},
          {name = 'path'},
        }, {
          {name = 'buffer', keyword_length = 3},
        }),
        mapping = cmp.mapping.preset.insert({
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
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
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "lua_ls", 
          "ts_ls",  -- mason-lspconfigでのTypeScript LSPの名前
          "terraformls",  -- Terraform Language Server
          "rust_analyzer"  -- Rust Language Server
        },
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
                  runtime = {
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                }
              }
            }
          end,
          
          ["ts_ls"] = function ()
            require('lspconfig').ts_ls.setup {
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              on_attach = function (client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
              end
            }
          end,
          
          ["rust_analyzer"] = function ()
            require('lspconfig').rust_analyzer.setup {
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              root_dir = function(fname)
                local util = require('lspconfig').util
                -- Cargoがインストールされていない場合のエラーを回避
                local ok, result = pcall(util.root_pattern("Cargo.toml"), fname)
                if ok and result then
                  return result
                end
                -- フォールバック: .gitディレクトリまたは現在のディレクトリ
                return util.root_pattern(".git")(fname) or util.path.dirname(fname)
              end,
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    buildScripts = {
                      enable = true,
                      rebuildOnSave = false,
                    },
                  },
                  checkOnSave = false,
                  procMacro = {
                    enable = true,
                  },
                  inlayHints = {
                    bindingModeHints = { enable = false },
                    chainingHints = { enable = false },
                    closingBraceHints = { enable = false },
                    closureReturnTypeHints = { enable = "never" },
                    lifetimeElisionHints = { enable = "never" },
                    parameterHints = { enable = false },
                    typeHints = { enable = false },
                  },
                }
              }
            }
          end
      }
      })
    end
  },

  "neovim/nvim-lspconfig",

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "ktlint",   -- kotlin linter/formatter
          "eslint_d", -- eslint daemon
        },
        automatic_installation = true,
      })
    end,
  },

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
          theme = 'tokyonight'
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
      "williamboman/mason-lspconfig.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        debug = false,  -- パフォーマンス: ログ出力を無効化
        sources = {
          require("none-ls.diagnostics.eslint"),
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.ktlint,
          null_ls.builtins.formatting.ktlint,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false, bufnr = bufnr, timeout_ms = 5000 })
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
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
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
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".gradle/",
            "build/",
            "dist/",
            "target/",
            "%.lock",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
            "--glob=!node_modules/",
            "--glob=!target/",
          },
        },
        pickers = {
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      }
      require('telescope').load_extension('fzf')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "rust", "lua", "typescript", "javascript",
          "json", "yaml", "toml", "kotlin", "terraform", "sql",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,  -- 二重処理防止
        },
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
          lsp_doc_border = true,
        },
        routes = {
          { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
          { filter = { event = "msg_show", kind = "wmsg" }, view = "mini" },
        },
        throttle = 1000 / 30,
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
vim.keymap.set('n', '<Leader>df', function()
  -- 現在のファイル情報を保存
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local current_pos = vim.api.nvim_win_get_cursor(0)
  
  -- 定義位置を取得
  vim.lsp.buf_request(0, 'textDocument/definition', vim.lsp.util.make_position_params(), function(err, result, ctx, config)
    if err then
      vim.notify('Error: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    
    if not result or vim.tbl_isempty(result) then
      vim.notify('No definition found', vim.log.levels.INFO)
      return
    end
    
    -- 結果を正規化（単一の結果でも配列として扱う）
    if not vim.islist(result) then
      result = { result }
    end
    
    local location = result[1]
    local target_uri = location.uri or location.targetUri
    local target_range = location.range or location.targetRange
    
    if not target_uri then
      return
    end
    
    local target_file = vim.uri_to_fname(target_uri)
    
    -- 同一ファイルかどうかチェック
    if target_file == current_file then
      -- 同一ファイル内でジャンプ
      if target_range then
        local row = target_range.start.line + 1
        local col = target_range.start.character + 1
        -- ジャンプリストに追加
        vim.cmd("normal! m'")
        vim.api.nvim_win_set_cursor(0, {row, col})
      end
    else
      -- 別ファイルなら新しいタブで開く
      vim.cmd('tabnew')
      vim.cmd('edit ' .. vim.fn.fnameescape(target_file))
      
      -- カーソル位置を設定
      if target_range then
        local row = target_range.start.line + 1
        local col = target_range.start.character + 1
        vim.api.nvim_win_set_cursor(0, {row, col})
      end
      
      -- ジャンプリストに追加（元の位置に戻れるように）
      vim.cmd("normal! m'")
    end
  end)
end, bufopts)
vim.keymap.set('n', '<Leader>v', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<Leader>fmt', function() vim.lsp.buf.format { async = true } end, bufopts)

-- JetBrains Kotlin LSPの手動設定
-- NOTE: kotlin-lspが重すぎるため一時的に無効化
-- local lspconfig = require('lspconfig')
-- local configs = require('lspconfig.configs')
-- 
-- -- カスタムLSPサーバーとして登録
-- if not configs.kotlin_lsp then
--   configs.kotlin_lsp = {
--     default_config = {
--       cmd = { 'kotlin-lsp', '--stdio' }, -- stdio モードで起動
--       filetypes = { 'kotlin', 'kt' },
--       -- コンポジットビルド対応: 親プロジェクトのルートを優先的に探す
--       root_dir = function(fname)
--         local util = lspconfig.util
--         
--         -- 現在のファイルから上位に向かって探索
--         local root = util.root_pattern('settings.gradle', 'settings.gradle.kts')(fname)
--         
--         if root then
--           -- settings.gradleの内容を確認してincludeBuildがあるか調べる
--           local settings_file = root .. '/settings.gradle.kts'
--           if not vim.fn.filereadable(settings_file) then
--             settings_file = root .. '/settings.gradle'
--           end
--           
--           -- 親ディレクトリも確認（コンポジットビルドの親の可能性）
--           local parent = vim.fn.fnamemodify(root, ':h')
--           local parent_settings = util.root_pattern('settings.gradle', 'settings.gradle.kts')(parent)
--           if parent_settings then
--             root = parent_settings
--           end
--         end
--         
--         return root or util.root_pattern('build.gradle', 'build.gradle.kts', 'pom.xml', '.git')(fname)
--       end,
--       settings = {},
--       init_options = {
--         storagePath = vim.fn.stdpath('cache') .. '/kotlin-lsp',
--       },
--     },
--   }
-- end
-- 
-- -- LSPセットアップ（ワークスペース設定を追加）
-- lspconfig.kotlin_lsp.setup {
--   capabilities = require('cmp_nvim_lsp').default_capabilities(),
--   on_attach = function(client, bufnr)
--     -- コンポジットビルドの追加フォルダを検出して登録
--     local root_dir = client.config.root_dir
--     if root_dir then
--       -- settings.gradleからincludeBuildを探す
--       local settings_files = vim.fn.glob(root_dir .. '/settings.gradle*', false, true)
--       for _, settings_file in ipairs(settings_files) do
--         local content = vim.fn.readfile(settings_file)
--         for _, line in ipairs(content) do
--           -- includeBuild ディレクティブを探す
--           local included = line:match('includeBuild%s*%(?["\']([^"\']+)["\']')
--           if included then
--             local included_path = root_dir .. '/' .. included
--             if vim.fn.isdirectory(included_path) then
--               -- ワークスペースフォルダとして追加
--               vim.lsp.buf.add_workspace_folder(included_path)
--             end
--           end
--         end
--       end
--     end
--   end,
-- }

require("disable_default_plugin")
require("keymaps")
require("options")

vim.api.nvim_create_user_command("FilePath", ":echo expand('%')", { nargs = 0 })

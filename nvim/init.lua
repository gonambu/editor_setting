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
  use {'neoclide/coc.nvim', branch = 'release'}
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
  use {'nvim-lualine/lualine.nvim', config = function() require('lualine').setup() end}
  use 'glidenote/memolist.vim'
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.1',
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
        -- ensure_installed = { "typescript", "python", "scss", "json", "css", "markdown", "vim", "lua" },
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
end)

vim.g.loaded_2html_plugin       = 1
vim.g.loaded_gzip               = 1
vim.g.loaded_tar                = 1
vim.g.loaded_tarPlugin          = 1
vim.g.loaded_zip                = 1
vim.g.loaded_zipPlugin          = 1
vim.g.loaded_vimball            = 1
vim.g.loaded_vimballPlugin      = 1
vim.g.loaded_netrw              = 1
vim.g.loaded_netrwPlugin        = 1
vim.g.loaded_netrwSettings      = 1
vim.g.loaded_netrwFileHandlers  = 1
vim.g.loaded_getscript          = 1
vim.g.loaded_getscriptPlugin    = 1
vim.g.loaded_man                = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_shada_plugin       = 1
vim.g.loaded_spellfile_plugin   = 1
vim.g.loaded_tutor_mode_plugin  = 1
vim.g.loaded_remote_plugins     = 1
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu   = 1
vim.g.skip_loading_mswin        = 1
vim.g.did_indent_on             = 1
vim.g.did_load_ftplugin         = 1
vim.g.loaded_rrhelper           = 1

vim.cmd("colorscheme hybrid")

vim.cmd([[
    function! ChoseAction(actions) abort
    echo join(map(copy(a:actions), { _, v -> v.text }), ", ") .. ": "
    let result = getcharstr()
    let result = filter(a:actions, { _, v -> v.text =~# printf(".*\(%s\).*", result)})
    return len(result) ? result[0].value : ""
    endfunction

    function! CocJumpAction() abort
    let actions = [
            \ {"text": "(s)plit", "value": "split"},
            \ {"text": "(v)slit", "value": "vsplit"},
            \ {"text": "(t)ab", "value": "tabedit"},
            \ ]
    return ChoseAction(actions)
    endfunction
]])

vim.cmd([[
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
]])


local keymap = {
    {"n", "j", "gj", {noremap=true}},
    {"n", "k", "gk", {noremap=true}},
    {"n", "+", "<C-a>", {noremap=true}},
    {"n", "-", "<C-x>", {noremap=true}},
    {"", "<S-h>", "^", {noremap=true}},
    {"", "<S-l>", "$", {noremap=true}},
    {"n", "s", "<Nop>", {}},
    {"x", "s", "<Nop>", {}},
    {"n", "<Esc><Esc>", ":nohlsearch<CR><Esc>", {noremap=true, silent=true}},

    -- tab
    {"n", "<Space>t", ":tabnew<CR>", {noremap=true, silent=true}},
    {"n", "<Space>h", ":tabprevious<CR>", {noremap=true, silent=true}},
    {"n", "<Space>l", ":tabnext<CR>", {noremap=true, silent=true}},

    -- telescope
    {"n", "<Space><Space>f", "<cmd>Telescope find_files<cr>", {noremap=true, silent=true}},
    {"n", "<Space><Space>b", "<cmd>Telescope buffers<cr>", {noremap=true, silent=true}},
    {"n", "<leader>g", "<cmd>Telescope live_grep<cr>", {noremap=true, silent=true}},

    -- window移動
    {"n", "<C-h>", "<C-w>h", {noremap=true, silent=true}},
    {"n", "<C-l>", "<C-w>l", {noremap=true, silent=true}},
    {"n", "<C-j>", "<C-w>j", {noremap=true, silent=true}},
    {"n", "<C-k>", "<C-w>k", {noremap=true, silent=true}},

    -- coc
    {"n", "<leader>rn", "<Plug>(coc-rename)", {silent=true}},
    {"n", "<leader>rf", "<Plug>(coc-references)", {silent=true}},
    {"n", "<leader>df", ":<C-u>call CocActionAsync('jumpDefinition', CocJumpAction())<CR>", {noremap=true, silent=true}},
    {"n", "<leader>td", "<Plug>(coc-type-definition)<CR>", {noremap=true, silent=true}},
    {"n", "<leader>v", ":<C-u>call CocAction('doHover')<cr>", {silent=true}},
}

for k, v in pairs(keymap) do
    vim.api.nvim_set_keymap(v[1], v[2], v[3], v[4])
end

local options = {
    autoread=true,
    backspace="indent,eol,start",
    backup=false,
    clipboard="unnamedplus",
    encoding="utf-8",
    expandtab=true,
    fileencodings="utf-8,sjis,iso-2022-jp,euc-jp",
    hidden=true,
    hlsearch=true,
    ignorecase=true,
    incsearch=true,
    laststatus=2,
    matchtime=1,
    number=true,
    scrolloff=9999,
    shiftround=true,
    shiftwidth=4,
    showcmd=true,
    showmatch=true,
    smartcase=true,
    smartindent=true,
    splitright=true,
    swapfile=false,
    virtualedit="onemore",
    visualbell=true,
    wildmenu=true,
    wildmode="list:longest",
    wrapscan=true,
    list=true,
    listchars={tab="▸-"},
}

for k, v in pairs(options) do
    vim.opt[k] = v
end


vim.api.nvim_create_user_command("Format", ":call CocActionAsync('format')", { nargs = 0 })
vim.api.nvim_create_user_command("Prettier", ":CocCommand prettier.forceFormatDocument", { nargs = 0 })
vim.api.nvim_create_user_command("FilePath", ":echo expand('%')", { nargs = 0 })

return {
  {
    "machakann/vim-sandwich",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>n", function() require("oil").toggle_float() end, desc = "Toggle Oil file explorer" },
    },
    cmd = "Oil",
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      view_options = { show_hidden = true },
      float = {
        padding = 2,
        max_width = 80,
        max_height = 30,
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["q"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
      },
    },
  },

  {
    "tyru/open-browser.vim",
    keys = {
      { "<Leader>b", "<Plug>(openbrowser-smart-search)", mode = { "n", "x" }, desc = "Open browser search" },
    },
  },

  {
    "tyru/open-browser-github.vim",
    cmd = "OpenGithubFile",
    dependencies = { "tyru/open-browser.vim" },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { theme = "tokyonight" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        offsets = {
          { filetype = "oil", text = "File Explorer", text_align = "center" },
        },
        custom_filter = function(buf_number)
          return vim.bo[buf_number].buftype ~= "terminal"
        end,
      },
    },
    keys = {
      { "<Space>h", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<Space>l", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      {
        "<Space>x",
        function()
          local buf = vim.api.nvim_get_current_buf()
          vim.cmd("BufferLineCyclePrev")
          vim.cmd("bdelete " .. buf)
        end,
        desc = "Close buffer",
      },
      { "<Space>X", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "<Space>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<Space>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<Space>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<Space>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<Space>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
    },
  },
}

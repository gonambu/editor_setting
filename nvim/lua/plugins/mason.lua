return {
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^2.0.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", version = "^2.0.0", cmd = "Mason", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "ts_ls", "terraformls", "rust_analyzer" },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "prettier", "eslint_d", "ktlint" },
    },
  },
}

local prettier_ft = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "yaml",
  "css",
  "html",
  "markdown",
}

local eslint_ft = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    opts = function()
      local formatters_by_ft = { kotlin = { "ktlint" } }
      for _, ft in ipairs(prettier_ft) do
        formatters_by_ft[ft] = { "prettier" }
      end

      return {
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          timeout_ms = 3000,
          lsp_format = "fallback",
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = { kotlin = { "ktlint" } }
      for _, ft in ipairs(eslint_ft) do
        lint.linters_by_ft[ft] = { "eslint_d" }
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("NvimLint", {}),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

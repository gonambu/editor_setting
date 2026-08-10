local parsers = {
  "bash",
  "go",
  "hcl",
  "javascript",
  "json",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "proto",
  "rust",
  "sql",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      local installed = ts.get_installed("parsers")
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, parsers)
      if #missing > 0 then
        ts.install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", {}),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and vim.tbl_contains(ts.get_installed("parsers"), lang) then
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })
    end,
  },
}

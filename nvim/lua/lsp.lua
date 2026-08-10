vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        buildScripts = { enable = true, rebuildOnSave = false },
      },
      checkOnSave = false,
      procMacro = { enable = true },
      inlayHints = {
        bindingModeHints = { enable = false },
        chainingHints = { enable = false },
        closingBraceHints = { enable = false },
        closureReturnTypeHints = { enable = "never" },
        lifetimeElisionHints = { enable = "never" },
        parameterHints = { enable = false },
        typeHints = { enable = false },
      },
    },
  },
})

-- 定義が別ファイルなら新しいタブで開く
local function goto_definition()
  vim.lsp.buf.definition({
    on_list = function(options)
      local item = options.items[1]
      if item == nil then
        vim.notify("No definition found", vim.log.levels.INFO)
        return
      end

      vim.cmd("normal! m'")
      if item.filename ~= vim.api.nvim_buf_get_name(0) then
        vim.cmd.tabedit(vim.fn.fnameescape(item.filename))
      end
      vim.api.nvim_win_set_cursor(0, { item.lnum, math.max(item.col - 1, 0) })
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspKeymaps", {}),
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set("n", "<Leader>df", goto_definition, opts)
    vim.keymap.set("n", "<Leader>v", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<Leader>rf", "<cmd>FzfLua lsp_references<cr>", opts)
  end,
})

vim.keymap.set("n", "<Leader>fmt", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true })

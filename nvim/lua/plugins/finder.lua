local excludes = { ".git", "node_modules", "target", "build", "dist", ".gradle" }

local function fd_opts()
  local opts = "--color=never --type f --hidden --follow"
  for _, dir in ipairs(excludes) do
    opts = opts .. " --exclude " .. dir
  end
  return opts
end

-- 末尾の -e は fzf-lua が検索語を連結する位置。落とすと検索が常に 0 件になる
local function rg_opts()
  local opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden"
  for _, dir in ipairs(excludes) do
    opts = opts .. " -g '!" .. dir .. "/'"
  end
  return opts .. " -e"
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    opts = {
      files = { fd_opts = fd_opts() },
      grep = { rg_opts = rg_opts() },
      keymap = {
        fzf = { ["esc"] = "abort" },
      },
      winopts = {
        -- fzf は terminal buffer で動くので keymaps.lua の terminal window 移動が候補移動を奪う
        on_create = function()
          for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
            vim.keymap.set("t", key, key, { buffer = true, nowait = true })
          end
        end,
      },
    },
  },
}

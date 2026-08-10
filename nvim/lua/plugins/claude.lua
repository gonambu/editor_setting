return {
  {
    "coder/claudecode.nvim",
    cmd = {
      "ClaudeCode",
      "ClaudeCodeOpen",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
      },
    },
    keys = {
      { "<C-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<Leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<Leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<Leader>ao", "<cmd>ClaudeCodeOpen<cr>", desc = "Open file in Claude" },
      { "<Leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
    },
  },
}

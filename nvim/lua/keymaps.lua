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
}

for _, v in pairs(keymap) do
    vim.api.nvim_set_keymap(v[1], v[2], v[3], v[4])
end

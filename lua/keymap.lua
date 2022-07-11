local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
vim.g.mapleader = ","
vim.g.maplocalleader = ","

keymap("n", "<space><space>", ":b#<CR>", opts)
keymap("n", "Y", "yg_", opts)
keymap("n", "<Esc>", "<C-><C-n>", opts)
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)
keymap("n", "<C-Left>", "<C-w>h", opts)
keymap("n", "<C-Right>", "<C-w>l", opts)
keymap("n", "<C-Up>", "<C-w>k", opts)
keymap("n", "<C-Down>", "<C-w>j", opts)
keymap("n", "<space>wv", ":vsplit<CR>", opts)
keymap("n", "<space>wh", ":vsplit<CR>", opts)
keymap("n", "<space>t", ":belowright split term://fish | resize 11<CR>", opts)
keymap("n", "<C-space>", ":unhide<CR><Esc>", opts)

keymap("v", "<leader>y", '"+y', opts)

keymap("t", "<C-Up>", "<C-\\><C-n><C-w>k", opts)
keymap("t", "<C-space>", "<C-\\><C-n>:hide<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)


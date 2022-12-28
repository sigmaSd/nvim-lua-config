local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- save with ctrl-s
keymap("i", "<C-s>", "<Esc>:w<CR>", opts)
keymap("n", "<C-s>", "<Esc>:w<CR>", opts)
--keymap("n", "<C-x>", ":qa<CR>", opts)

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

vim.keymap.set("n", "<space>dr", function()
    vim.lsp.codelens.refresh();
    vim.lsp.codelens.run()
end, opts)


-- close quicky
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("qfexit", { clear = true }),
    pattern = { 'qf', 'help', 'tsplayground', 'preview' },
    callback = function(params)
        vim.api.nvim_buf_set_keymap(params.buf, "n", "q", ":q<CR>", opts)
    end,
})

keymap("v", "<leader>y", '"+y', opts)

keymap("t", "<C-Up>", "<C-\\><C-n><C-w>k", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

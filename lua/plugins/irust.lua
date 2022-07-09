local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<space>ii", ":IRust<CR>", opts)
keymap("n", "<space>ir", ":IRustReset<CR>", opts)
keymap("n", "<space>iw", ":IRustSendCurrentWord<CR>", opts)
keymap("n", "<space>il", ":IRustSendCurrentLine<CR>", opts)
keymap("n", "<space>ic", ":IRustSyncToCursor<CR>", opts)
keymap("n", "<space>ick", ":IRustSyncCrateToCursor<CR>", opts)
keymap("v", "<space>is", ":IRustSendSelection<CR>", opts)

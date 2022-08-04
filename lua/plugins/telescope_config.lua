local set = vim.keymap.set

vim.api.nvim_set_keymap("n", "<space>ft", ":Telescope<CR>", { noremap = true, silent = true })
set("n", "<space>fc", function() require('telescope.builtin').commands() end)
set("n", "<space>ff", function() require('telescope.builtin').find_files() end)
set("n", "<space>fg", function() require('telescope.builtin').live_grep() end)
set("n", "<space>fb", function() require('telescope.builtin').buffers() end)
set("n", "<space>fh", function() require('telescope.builtin').help_tags() end)
set("n", "<space>fo", function() require('telescope.builtin').oldfiles() end)

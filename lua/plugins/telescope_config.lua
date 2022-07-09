local set = vim.keymap.set

set("n", "<space>ff", function() require('telescope.builtin').find_files() end)
set("n", "<space>fg", function() require('telescope.builtin').live_grep() end)
set("n", "<space>fb", function() require('telescope.builtin').buffers() end)
set("n", "<space>fh", function() require('telescope.builtin').help_tags() end)

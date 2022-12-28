local set = vim.keymap.set

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
        }
    },
}

vim.api.nvim_set_keymap("n", "<space>ss", ":Telescope<CR>", { noremap = true, silent = true })
set("n", "<space>sc", function() require('telescope.builtin').commands() end)
set("n", "<space>f", function() require('telescope.builtin').find_files() end)
set("n", "<space>sg", function() require('telescope.builtin').live_grep() end)
set("n", "<space>b", function() require('telescope.builtin').buffers() end)
set("n", "<space>sh", function() require('telescope.builtin').help_tags() end)
set("n", "<space>so", function() require('telescope.builtin').oldfiles() end)

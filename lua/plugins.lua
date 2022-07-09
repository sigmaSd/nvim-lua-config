local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bontstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.api.nvim_command('packadd packer.nvim')
end

require('packer').startup(function(use)
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "ellisonleao/gruvbox.nvim" }
    use {
        "windwp/nvim-autopairs",
        --     config = function() require("nvim-autopairs").setup {} end
        --     config is done inside coc to synchronize with it
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    -- these next plugins are *not* written in lua
    use { 'neoclide/coc.nvim', branch = 'release' }
    use 'github/copilot.vim'
    use 'vim-denops/denops.vim'
    use 'sigmaSd/irust-vim-plugin'
    use 'sigmaSd/runner'

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- helpers
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- copilot
vim.g.copilot_node_command = "~/dev/node/bin/node16"
-- nvim-tree
require("nvim-tree").setup()
keymap("n", "<leader>n", ":NvimTreeFocus<CR>", opts)
-- irust
require("plugins/irust")
-- lualine
require("lualine").setup({
    sections = {
        lualine_c = { 'coc#status', 'b:coc_current_function' }
    }
})
-- coc
require("plugins/coc")
-- telescope
require("plugins/telescope_config")
-- gruvbox
require("gruvbox").setup({
    italic = false,
})
vim.cmd("colorscheme gruvbox")
-- runner
keymap("n", "<C-x>", ":RunFile run<CR>", opts)
keymap("n", "<C-a>", ":RunFile repl<CR>", opts)

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bontstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.api.nvim_command('packadd packer.nvim')
end

require('packer').init({
    autoremove = true, -- Remove disabled or unused plugins without prompting the user
})

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Packer itself

    use({ "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    })

    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "ellisonleao/gruvbox.nvim" }
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
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
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer'
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use "rafamadriz/friendly-snippets"
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    use {
        'lewis6991/spellsitter.nvim',
        config = function()
            require('spellsitter').setup()
        end
    }
    use("j-hui/fidget.nvim")
    use { 'rafcamlet/nvim-luapad', requires = "antoinemadec/FixCursorHold.nvim" }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use 'nvim-treesitter/playground'
    use 'theHamsta/nvim-treesitter-pairs'
    use 'glepnir/dashboard-nvim'
    use {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            require 'hop'.setup()
        end
    }
    use {
        "nvim-neorg/neorg",
        config = function()
            require('neorg').setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.norg.dirman"] = {
                        config = {
                            workspaces = {
                                work = "~/notes/work",
                                home = "~/notes/home",
                            }
                        }
                    },
                    ["core.norg.concealer"] = {},
                    ["core.norg.completion"] = {
                        config = {
                            engine = "nvim-cmp"
                        }
                    },
                }
            }
        end,
        tag = "*",
        requires = "nvim-lua/plenary.nvim"
    }
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup()
        end,
        requires = { "nvim-lua/plenary.nvim" },
    })

    use({
        '/home/mrcool/dev/nvim-plugins/tailwind/',
        --'sigmaSd/nvim-tailwind',
        requires = {
            "jose-elias-alvarez/null-ls.nvim",
            'nvim-treesitter/nvim-treesitter',
        }
    })
    use '/home/mrcool/dev/nvim-plugins/inject'
    use { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' }
    use {
        'Olical/conjure',
        branch = 'develop', -- needed for now until next conjure release
    }
    use {
        --'sigmaSd/conjure-deno'
        '/home/mrcool/dev/nvim-plugins/conjure/deno',
    }
    use '/home/mrcool/dev/nvim-plugins/nvim-deno/'

    -- these next plugins are *not* written in lua
    -- use { 'github/copilot.vim'}
    -- use 'vim-denops/denops.vim'
    -- use 'sigmaSd/irust-vim-plugin'
    -- use 'sigmaSd/runner'

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- helpers
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- copilot
--vim.g.copilot_node_command = "~/dev/node/bin/node16"
--vim.g.copilot_no_tab_map = true
--keymap("i", "<Plug>(vimrc:copilot-dummy-map)", 'copilot#Accept("<Tab>")', { expr = true })

-- nvim-tree
require('nvim-tree').setup {
    update_focused_file = {
        enable = true,
        update_cwd = true,
    }
}
keymap("n", "<leader>n", ":NvimTreeFocus<CR>", opts)
-- irust
require("plugins/irust")
-- lualine
require("lualine").setup({})
-- telescope
require("plugins/telescope_config")
-- gruvbox
require("gruvbox").setup({
    italic = false,
})
vim.cmd("colorscheme gruvbox")
-- runner
--keymap("n", "<C-x>", ":RunFile run<CR>", opts)
keymap("n", "<C-a>", ":RunFile run<CR>", opts)
-- lsp
require("plugins/lsp")
-- tree-sitter
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    pairs = {
        enable = true,
        highlight_pair_events = { "CursorMoved" },
        highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
    }
}
-- fidget (lsp progress)
require("fidget").setup()

-- dashboard
require("plugins/dashboard_conf")


--hop
vim.api.nvim_set_keymap('', 'f',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
    , {})
vim.api.nvim_set_keymap('', 'F',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
    , {})
vim.api.nvim_set_keymap('', 't',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false})<cr>"
    , {})
vim.api.nvim_set_keymap('', 'T',
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>"
    , {})


--code runner
local typescript_run = function(arg)
    local filepath = vim.fn.expand("%:p")
    local commands = require("code_runner.commands")

    if not arg or arg == "run" then
        commands.run_mode("deno run -A --unstable " .. filepath, "deno run", "term")
    elseif arg == "repl" then
        commands.run_mode(
            string.format(
                [[deno repl --unstable --eval "import * as m from 'file:///%s';Object.entries(m).forEach(e=>window[e[0] ]=e[1])"]]
                , filepath),
            "repl",
            "toggle"
        )
    end
end
require('code_runner').setup({
    filetype = {
        typescript = typescript_run,
        typescriptreact = typescript_run,
        rust = "cargo r",
    },
})
vim.keymap.set('n', '<leader>x', function()
    local commands = require("code_runner.commands")
    local filetype = vim.api.nvim_exec("echo &filetype", true)
    commands.run_code(filetype, "run")
end, { noremap = true, silent = false })

-- vim.keymap.set('n', '<leader>r', function()
--     local filename = vim.fn.expand("%:t")
--     if filename:match("^crunner_repl") then
--         vim.cmd("hide")
--         return
--     end
--     local commands = require("code_runner.commands")
--     local filetype = vim.api.nvim_exec("echo &filetype", true)
--
--     commands.run_code(filetype, "repl")
-- end, { noremap = true, silent = false })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)


require('lazy').setup({
    'hkupty/iron.nvim',
    'nvim-treesitter/nvim-treesitter-textobjects',

    { "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },

    -- Lua
    {
        "folke/neoconf.nvim",
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    { "ellisonleao/gruvbox.nvim" },
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
    },
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        version = 'nightly' -- optional, updated every week. (see issue #1193)
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    },
    {
        'lewis6991/spellsitter.nvim',
        config = function()
            require('spellsitter').setup()
        end
    },
    'nvim-treesitter/playground',

    'neovim/nvim-lspconfig', -- Configurations for Nvim LSP
    'lvimuser/lsp-inlayhints.nvim',
    'j-hui/fidget.nvim',

    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',
    'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
    'L3MON4D3/LuaSnip', -- Snippets plugin
    "rafamadriz/friendly-snippets",


    { 'rafcamlet/nvim-luapad', requires = "antoinemadec/FixCursorHold.nvim" },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    --  'theHamsta/nvim-treesitter-pairs'
    'glepnir/dashboard-nvim',
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            require 'hop'.setup()
        end
    },
    --  {
    --     "nvim-neorg/neorg",
    --     config = function()
    --         require('neorg').setup {
    --             load = {
    --                 ["core.defaults"] = {},
    --                 ["core.norg.dirman"] = {
    --                     config = {
    --                         workspaces = {
    --                             work = "~/notes/work",
    --                             home = "~/notes/home",
    --                         }
    --                     }
    --                 },
    --                 ["core.norg.concealer"] = {},
    --                 ["core.norg.completion"] = {
    --                     config = {
    --                         engine = "nvim-cmp"
    --                     }
    --                 },
    --             }
    --         }
    --     end,
    --     tag = "*",
    --     requires = "nvim-lua/plenary.nvim"
    -- }
    -- ({
    --     "jose-elias-alvarez/null-ls.nvim",
    --     config = function()
    --         require("null-ls").setup()
    --     end,
    --     requires = { "nvim-lua/plenary.nvim" },
    -- })

    -- ({
    --     '/home/mrcool/dev/nvim-plugins/tailwind/',
    --     --'sigmaSd/nvim-tailwind',
    --     requires = {
    --         "jose-elias-alvarez/null-ls.nvim",
    --         'nvim-treesitter/nvim-treesitter',
    --     }
    -- })
    --  '/home/mrcool/dev/nvim-plugins/inject'
    --  { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' }
    -- "lukas-reineke/indent-blankline.nvim"
    {
        'Olical/conjure',
    },
    {
        'sigmaSd/conjure-deno'
        -- '/home/mrcool/dev/nvim-plugins/conjure/deno',
    },
    'sigmaSd/deno-nvim',


    -- these next plugins are *not* written in lua
    --  { 'github/copilot.vim'}
    --  'vim-denops/denops.vim'
    --  'sigmaSd/irust-vim-plugin'
    --  'sigmaSd/runner'

})


-- helpers
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- copilot
--vim.g.copilot_node_command = "~/dev/node/bin/node16"
--vim.g.copilot_no_tab_map = true
--keymap("i", "<Plug>(vimrc:copilot-dummy-map)", 'copilot#Accept("<Tab>")', { expr = true })

-- nvim-tree
require('nvim-tree').setup()
--     update_focd_file = {
--         enable = true,
--         update_cwd = true,
--     }
-- }
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
-- require('code_runner').setup({
--     filetype = {
--         javascript = typescript_run,
--         typescript = typescript_run,
--         typescriptreact = typescript_run,
--         javascriptreact = typescript_run,
--         rust = "cargo r",
--     },
-- })
-- vim.keymap.set('n', '<leader>x', function()
--     local commands = require("code_runner.commands")
--     local filetype = vim.api.nvim_exec("echo &filetype", true)
--     commands.run_code(filetype, "run")
-- end, { noremap = true, silent = false })
--
-- vim.keymap.set('n', '<leader>a', function()
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
--
--
--
local iron = require("iron.core")

local bracketed_paste = require("iron.fts.common").bracketed_paste
iron.setup {
    config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
            typescript = {
                command = function(meta)
                    return { "deno", "repl", "-A", "--eval", string.format("Deno.chdir('%s')",
                        vim.fn.fnamemodify(vim.api.nvim_buf_get_name(meta.current_bufnr), ':h')
                    ) } -- set deno repl cwd to current file parent dir
                end,
                format = bracketed_paste
            }
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require('iron.view').right(60)
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
        italic = true
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')


require 'nvim-treesitter.configs'.setup {
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
        },
    },
}

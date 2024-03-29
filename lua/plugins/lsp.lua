local opts = { noremap = true, silent = true }

-- luasnip setup
local luasnip = require 'luasnip'
require("luasnip.loaders.from_vscode").lazy_load()

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        -- ['<C-g>'] = cmp.mapping(function()
        --     vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)),
        --         'n', true)
        -- end)
    }),
    experimental = {
        --ghost_text = false -- this feature conflict with copilot.vim's preview.
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer',
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        { name = 'path' },
        { name = 'neorg' },
    },
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>dd', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '(d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ')d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, opts)


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>l', function()
        vim.lsp.codelens.refresh()
    end, bufopts)
    vim.keymap.set('n', '<space>lr', function()
        vim.lsp.codelens.run()
    end, bufopts)
    vim.keymap.set('n', '<space>lf', vim.lsp.buf.format, bufopts)

end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()


require("neoconf").setup()
local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'rust_analyzer', 'pyright', 'clojure_lsp', 'nimls', 'jsonls', 'yamlls' }

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- lspconfig['dartls'].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { '/opt/flutter/bin/dart', 'language-server', '--protocol=lsp' }
-- }
lspconfig['svelte'].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = require "lspconfig.util".root_pattern('package.json', 'vite.config.mjs'),
}
-- lspconfig['tsserver'].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     root_dir = require "lspconfig.util".root_pattern('package.json'),
-- }
--
lspconfig.sumneko_lua.setup {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,
}

require "deno-nvim".setup({
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = require "lspconfig.util".root_pattern('deno.json', 'deno.jsonc', 'denonvim.tag'),
        settings = {
            deno = {
                unstable = true,
                -- inlayHints = {
                --     parameterNames = {
                --         enabled = "all"
                --     },
                --     parameterTypes = {
                --         enabled = true
                --     },
                --     variableTypes = {
                --         enabled = true
                --     },
                --     propertyDeclarationTypes = {
                --         enabled = true
                --     },
                --     functionLikeReturnTypes = {
                --         enabled = true
                --     },
                --     enumMemberValues = {
                --         enabled = true
                -- }

            }
        }
    }
})

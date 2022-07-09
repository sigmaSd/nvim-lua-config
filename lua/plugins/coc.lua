local api = vim.api
local cmd = api.nvim_command
local fn = vim.fn

local function register_mappings(mappings, default_options)
    for mode, mode_mappings in pairs(mappings) do
        for _, mapping in pairs(mode_mappings) do
            local options = #mapping == 3 and table.remove(mapping) or default_options
            local prefix, cmd_from_map = unpack(mapping)
            pcall(vim.api.nvim_set_keymap, mode, prefix, cmd_from_map, options)
        end
    end
end

function _G.check_back_space()
    local col = fn.col('.') - 1
    if col == 0 or fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

function _G.show_docs()
    local cw = fn.expand('<cword>')
    if fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
        cmd('h ' .. cw)
    elseif api.nvim_eval('coc#rpc#ready()') then
        fn.CocActionAsync('doHover')
    else
        cmd('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

local function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

local function define_augroups(definitions) -- {{{1
    for group_name, definition in pairs(definitions) do
        vim.cmd("augroup " .. group_name)
        vim.cmd("autocmd!")

        for _, def in pairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            vim.cmd(command)
        end

        vim.cmd("augroup END")
    end
end

local mappings = {
    i = { -- Insert mode
        { "<TAB>", 'pumvisible() ? "<C-N>" : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', { expr = true } },
        { "<S-TAB>", 'pumvisible() ? "<C-P>" : "<C-H>"', { expr = true } },
        { "<C-SPACE>", 'coc#refresh()', { expr = true } },
        { '<C-F>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<Right>"',
            { expr = true, silent = true, nowait = true } },
        { '<C-B>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<Left>"',
            { expr = true, silent = true, nowait = true } },
    },
    n = { -- Normal mode
        { "K", '<CMD>lua _G.show_docs()<CR>', { silent = true } },
        { '(g', '<Plug>(coc-diagnostic-prev)', { noremap = false } },
        { ')g', '<Plug>(coc-diagnostic-next)', { noremap = false } },
        { 'gb', '<Plug>(coc-cursors-word)', { noremap = false } },
        { 'gd', '<Plug>(coc-definition)', { noremap = false } },
        { 'gy', '<Plug>(coc-type-definition)', { noremap = false } },
        { 'gi', '<Plug>(coc-implementation)', { noremap = false } },
        { 'gr', '<Plug>(coc-references)', { noremap = false } },
        { '<leader>rn', '<Plug>(coc-rename)', { noremap = false } },
        { '<leader>a ', '<Plug>(coc-codeaction-selected)', { noremap = false } },
        { '<leader>al', ':call CocActionAsync("codeLensAction")<cr>', { noremap = false } },

        { '<C-F>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-F>"',
            { expr = true, silent = true, nowait = true } },
        { '<C-B>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-B>"',
            { expr = true, silent = true, nowait = true } },
        { '<space>a', ':<C-u>CocList diagnostics<cr>', { noremap = false, nowait = true } },
        { '<space>e', ':<C-u>CocList extensions<cr>', { noremap = false, nowait = true } },
        { '<space>c', ':<C-u>CocList commands<cr>', { noremap = false, nowait = true } },
        { '<space>o', ':<C-u>CocList outline<cr>', { noremap = false, nowait = true } },
        { '<space>s', ':<C-u>CocList -I symbols<cr>', { noremap = false, nowait = true } },
        { '<space>j', ':<C-u>CocNext<CR>', { noremap = false, nowait = true } },
        { '<space>k', ':<C-u>CocPrev<CR>', { noremap = false, nowait = true } },
        { '<space>p', ':<C-u>CocListResume<CR>', { noremap = false, nowait = true } },
    },

    o = {},
    t = { -- Terminal mode
    },
    v = { -- Visual/Select mode
    },
    x = { -- Visual mode
        { '<leader>a ', '<Plug>(coc-codeaction-selected)', { noremap = false } },
        { "<leader>a", '<CMD>lua _G.show_docs()<CR>', { silent = true } },
    },
    [""] = {
    },
}

if isModuleAvailable('nvim-autopairs') then
    local remap = vim.api.nvim_set_keymap
    local npairs = require('nvim-autopairs')
    npairs.setup({ map_cr = false })

    _G.MUtils = {}

    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0 then
            return vim.fn["coc#_select_confirm"]()
        else
            return npairs.autopairs_cr()
        end
    end
    remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })
else
    mappings.i[#mappings.i + 1] = { '<CR>', 'pumvisible() ? coc#_select_confirm() : "<C-g>u<CR><c-r>=coc#on_enter()<CR>"',
        { expr = true, silent = true, noremap = true } }
end

vim.cmd([[
    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
]])



define_augroups({ _coc = {
    { 'filetype', 'typescript,json', 'setl', "formatexpr=CocAction('formatselected')" },
    { 'User', 'CocQuickfixChange', ':CocList', '--normal', 'quickfix' },
    { 'user', 'cocjumpplaceholder', 'call', "CocActionAsync('showSignatureHelp')" },
} })


register_mappings(mappings, { silent = true, noremap = true })

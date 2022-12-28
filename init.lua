require("options")
require("keymap")
require("plugins")
require("luaterm")
require("utils")
require("deno")
require("conjure")

-- vim.lsp.set_log_level("DEBUG")
---@diagnostic disable-next-line: unused-function, unused-local
local debug = false
function DEBUG_LSP_TOGGLE()
    if not debug then
        debug = true
        vim.lsp.set_log_level("DEBUG")
        print("Warning: lsp debug is on")
    else
        debug = false
        vim.lsp.set_log_level("ERROR")
        print("lsp debug is off")
    end
end

--debug_lsp()


-- local sockdir = vim.fn.expand("~/.cache/nvim")
-- if vim.fn.filereadable(sockdir .. '/server.pipe') == 0 then
--     vim.fn.serverstart(sockdir .. '/server.pipe');
-- end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("fmt", { clear = true }),
    pattern = { '*.ts', '*.js', '*.lua', '*.tsx', '*.rs' },
    callback = function()
        vim.lsp.buf.format()
    end
})

require("luasnip").filetype_extend("typescriptreact", { "html" })



-- vim.api.nvim_create_autocmd("BufNewFile", {
--     group = vim.api.nvim_create_augroup("conjure_log_buf", { clear = true }),
--     pattern = "conjure-log-*",
--     callback = function(params)
--         local bufnr = params.buf
--         vim.diagnostic.disable(bufnr)
--     end
-- })

require("lsp-inlayhints").setup()

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
})

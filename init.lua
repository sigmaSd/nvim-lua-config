require("options")
require("keymap")
require("plugins")
require("luaterm")
require("utils")
require("deno")
require("conjure")
--vim.lsp.set_log_level("DEBUG")


-- local sockdir = vim.fn.expand("~/.cache/nvim")
-- if vim.fn.filereadable(sockdir .. '/server.pipe') == 0 then
--     vim.fn.serverstart(sockdir .. '/server.pipe');
-- end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("fmt", { clear = true }),
    pattern = { '*.ts', '*.js', '*.lua' },
    callback = vim.lsp.buf.formatting_sync,
})

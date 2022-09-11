local conjure_filetypes = { "clojure", "fennel", "janet", "hy", "julia", "racket", "scheme", "lua", "lisp",
    "rust" }
for _, v in pairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
    conjure_filetypes[#conjure_filetypes + 1] = v
end

vim.g["conjure#filetypes"] = conjure_filetypes

local deno                                = "deno.deno"
vim.g["conjure#filetype#typescript"]      = deno
vim.g["conjure#filetype#typescriptreact"] = deno
vim.g["conjure#filetype#javascript"]      = deno
vim.g["conjure#filetype#javascriptreact"] = deno

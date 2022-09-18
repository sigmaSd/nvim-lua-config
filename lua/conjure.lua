local conjure_filetypes = { "clojure", "fennel", "janet", "hy", "julia", "racket", "scheme", "lua", "lisp", "rust" }

for _, v in pairs({ "typescript", "javascript" }) do
    conjure_filetypes[#conjure_filetypes + 1] = v
end

-- disable autostart
vim.g["conjure#client_on_load"] = false

vim.g["conjure#mapping#doc_word"] = "K"

vim.g["conjure#filetypes"] = conjure_filetypes

vim.g["conjure#filetype#typescript"] = "deno.deno"
vim.g["conjure#filetype#javascript"] = "deno.deno"

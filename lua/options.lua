-- options
local options = {
    shell = "/usr/bin/fish",
    mouse = "a",
    relativenumber = true,
    number = true,
    inccommand = "nosplit",
    hidden = true,
    compatible = false,
    showmatch = true,
    ignorecase = true,
    tabstop = 4,
    softtabstop = 4,
    expandtab = true,
    shiftwidth = 4,
    autoindent = true,
    swapfile = false,
    termguicolors = true,
    spell = true,
    guifont = "Cascadia Code",
    undofile = true,
    signcolumn = "no",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
-- path += **
vim.opt.path = vim.opt.path + "**"

-- more options
vim.cmd("syntax off")


-- start terminal in insert mode
vim.cmd("autocmd BufWinEnter,WinEnter term://* startinsert")

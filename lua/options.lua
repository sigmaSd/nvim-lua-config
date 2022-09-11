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
    guifont = "Cascadia Code:h13",
    undofile = true,
    signcolumn = "no",
    splitright = true,
    splitbelow = true,
}

--vim.g.denops_server_addr = "127.0.0.1:32123"

for k, v in pairs(options) do
    vim.opt[k] = v
end
-- path += **
vim.opt.path = vim.opt.path + "**"

-- more options


-- start terminal in insert mode
vim.cmd("autocmd BufWinEnter,WinEnter term://* startinsert")

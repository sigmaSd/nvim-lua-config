local lua_terminal_window = nil
local lua_terminal_buffer = nil
local lua_terminal_job_id = nil
local function lua_terminal_window_size()
    return tonumber(vim.api.nvim_exec("echo &lines", true)) / 4
end

local function LuaTerminalOpen()
    if vim.fn.bufexists(lua_terminal_buffer) == 0 then
        vim.api.nvim_command("new lua_terminal")
        vim.api.nvim_command("wincmd J")
        vim.api.nvim_command("resize " .. lua_terminal_window_size())
        lua_terminal_job_id = vim.fn.termopen(os.getenv("SHELL"), {
            detach = 1
        })
        vim.api.nvim_command("silent file Terminal 1")
        lua_terminal_window = vim.fn.win_getid()
        lua_terminal_buffer = vim.fn.bufnr('%')
        vim.opt.buflisted = false
    else
        if vim.fn.win_gotoid(lua_terminal_window) == 0 then
            vim.api.nvim_command("sp")
            vim.api.nvim_command("wincmd J")
            vim.api.nvim_command("resize " .. lua_terminal_window_size())
            vim.api.nvim_command("buffer Terminal 1")
            lua_terminal_window = vim.fn.win_getid()
        end
    end
    vim.cmd("startinsert")
end

local function LuaTerminalClose()
    if vim.fn.win_gotoid(lua_terminal_window) == 1 then
        vim.api.nvim_command("hide")
    end
end

local function LuaTerminalToggle()
    if vim.fn.win_gotoid(lua_terminal_window) == 1 then
        LuaTerminalClose()
    else
        LuaTerminalOpen()
    end
end

---@diagnostic disable-next-line: unused-local, unused-function
local function LuaTerminalExec(cmd)
    if vim.fn.win_gotoid(lua_terminal_window) == 0 then
        LuaTerminalOpen()
    end
    vim.fn.jobsend(lua_terminal_job_id, 'clear\n')
    vim.fn.jobsend(lua_terminal_job_id, cmd .. '\n')
    vim.api.nvim_command("normal! G")
    vim.api.nvim_command("wincmd p")
end

vim.keymap.set("n", "<space>t", LuaTerminalToggle)
vim.keymap.set("t", "<space>t", LuaTerminalToggle)

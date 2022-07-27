function Messages()
    local msgs = vim.api.nvim_exec("messages", true)
    vim.api.nvim_command("tabe")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(msgs, "\n"))
end
vim.api.nvim_command("command! Messages :lua Messages()")

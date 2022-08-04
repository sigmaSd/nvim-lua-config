function Messages()
    local msgs = vim.api.nvim_exec("messages", true)
    vim.api.nvim_command("tabe")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(msgs, "\n"))
end

vim.api.nvim_command("command! Messages :lua Messages()")

function PreviewDeno()
    local job = function(code)
        local cmd = { "deno", "eval", "--unstable", table.concat(code, "\n") }
        local opts = {
            env = {
                NO_COLOR = true
            }
        }
        return cmd, opts
    end
    local pattern = { '*.ts', '*.js' }
    Preview(job, pattern)
end

vim.api.nvim_create_user_command("PreviewDeno", ":lua PreviewDeno()", {})

function Preview(job, pattern)
    local code_buf = vim.api.nvim_get_current_buf()
    local preview_buf = (function()
        vim.cmd("vsplit new")
        vim.cmd [[
         setl buftype=nofile
         setl bufhidden=hide
         setl noswapfile
         setl filetype=preview
        ]]
        vim.cmd("wincmd L")
        return vim.api.nvim_get_current_buf()
    end)()
    local eval = function()
        local code = vim.api.nvim_buf_get_lines(code_buf, 0, -1, {})
        local cmd, opts = job(code)
        local default_opts = {
            stdout_buffered = true,
            stderr_buffered = true,
            on_stdout = function(_, data)
                vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, data)
            end,
            on_stderr = function(_, data)
                if #data == 1 and data[1] == "" then
                else
                    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, data)
                end
            end
        }
        vim.fn.jobstart(cmd, vim.tbl_extend("force", opts, default_opts))
    end

    local autocmd_id = vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = vim.api.nvim_create_augroup("run", { clear = true }),
        pattern = pattern,
        callback = eval
    })
    vim.api.nvim_create_autocmd("BufHidden", {
        group = vim.api.nvim_create_augroup("previewdel", { clear = true }),
        callback = function(params)
            local buf = params.buf
            local filetype = vim.fn.getbufvar(buf, '&filetype')
            if filetype == "preview" then
                vim.api.nvim_del_autocmd(autocmd_id)
            end
        end,
    })
    -- run eval once to get the first result to show
    eval()
end

function ChangeToCurrentFileDir()
    local current_file_dir = vim.fn.expand("%:p:h")
    vim.cmd("cd " .. current_file_dir)
end

vim.api.nvim_create_user_command("ChangeToCurrentFileDir", ":lua ChangeToCurrentFileDir()", {})

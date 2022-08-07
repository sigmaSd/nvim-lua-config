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

function DenoUpdateDep(line)
    -- if line doesn't resemble an http dependency, return
    if not string.match(line, "https://") then
        return
    end
    -- extract the url from the line
    local url = string.match(line, '"(.+)"')
    -- if the url doesn't contain '@' then there is nothing we can update
    if not url:match('@') then
        print("line doesn't contain an updateable module")
        return
    end
    -- extract the module name
    -- in this case its simple_shell
    local module = string.match(url, '/x/(.+@.+)')
    local namespace = module and "x" or "std"
    if not module then
        module = string.match(url, '/(std@.+)')
    end
    module = vim.split(module, '/')[1]
    -- fetch the latest version
    local latest_url = string.format('https://deno.land/%s/%s', namespace,
        namespace == "x" and vim.split(module, '@')[1] or "")
    local deno_fetch = function(target_url)
        local cmd = string.format([[
        const url = await fetch("%s", {
         "headers": {
            "Accept": "text/html",
            },
        }).then(r => r.url)
        console.log(url)
        ]], target_url)
        return vim.fn.system({ "deno", "eval", cmd })
    end
    local new_url = deno_fetch(latest_url)
    if not new_url:match('@') then
        print("could not find latest version")
        print("new url is: " .. new_url)
        return
    end
    local new_module = string.match(new_url, '/(.+@.+)/?')
    new_module = namespace == "x" and vim.split(new_module, '/')[4] or vim.split(new_module, '/')[3]
    new_module = vim.trim(new_module)
    if new_module == module then
        --print("module is already up to date")
        return
    end

    local new_line, _ = string.gsub(line, module, new_module)
    return new_line
end

function DenoMarkDeps()
    local namespace_id = vim.api.nvim_create_namespace("deno update")

    local buf = vim.api.nvim_get_current_buf()
    -- read buf
    local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    for i, line in ipairs(content) do
        if line:match('@') then
            local new_line = DenoUpdateDep(line)
            local mark
            if new_line then
                mark = "🔺"
            else
                mark = "✨"
            end
            vim.api.nvim_buf_set_extmark(buf, namespace_id, i - 1, -1, { id = i, virt_text = { { mark } }, })
        end
    end
end

function DenoUpdateAllDeps()
    local buf = vim.api.nvim_get_current_buf()
    local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    for i, line in ipairs(content) do
        if line:match('@') then
            local new_line = DenoUpdateDep(line)
            if new_line then
                content[i] = new_line
            end
        end
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    DenoMarkDeps()
end

vim.api.nvim_create_user_command("PreviewDeno", ":lua PreviewDeno()", {})
vim.api.nvim_create_user_command("DenoUpdateDep", ":lua DenoUpdateDep()", {})
vim.api.nvim_create_user_command("DenoMarkDeps", ":lua DenoMarkDeps()", {})
vim.api.nvim_create_user_command("DenoUpdateAllDeps", ":lua DenoUpdateAllDeps()", {})

return {
    "akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup({
            shade_terminals = false,
            direction = "vertical",
            size = function(term)
                if term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
                elseif term.direction == "horizontal" then
                    return math.floor(vim.o.lines * 0.4)
                end
            end,
            on_open = function(term)
                vim.api.nvim_win_set_option(term.window, "statuscolumn", "")
            end,
        })
    end,
    keys = {
        { "<leader>tt", "<CMD>ToggleTerm<CR>", desc = "Toggle Terminal" },
        {
            "<leader>tr",
            function()
                local filetype = vim.bo.filetype
                local relative_path = vim.fn.expand("%.")
                local head = vim.fn.expand("%:h") .. "/"
                local tail = vim.fn.expand("%:t")
                if head == "." then
                    head = "./" .. head
                end

                local command
                if filetype == "lua" then
                    -- LUA
                    command = "lua " .. relative_path
                elseif filetype == "python" then
                    -- PYTHON
                    command = "python " .. relative_path
                elseif filetype == "go" then
                    -- GO
                    command = "go run " .. relative_path
                elseif filetype == "java" then
                    -- JAVA
                    command = string.format("javac %s && java -cp %s %s", relative_path, head, tail:gsub(".java", ""))
                elseif filetype == "c" then
                    -- C
                    local output = string.format("%s", head .. tail:gsub(".c", ""))
                    command = string.format("gcc %s -o %s && %s", relative_path, output, output)
                elseif filetype == "cpp" then
                    -- C++
                    local output = string.format("%s", head .. tail:gsub(".cpp", ""))
                    command = string.format("g++ %s -o %s && %s", relative_path, output, output)
                elseif filetype == "rust" then
                    local output = string.format("%s", head .. tail:gsub(".rs", ""))
                    command = string.format("rustc %s -o %s && %s", relative_path, output, output)
                elseif filetype == "sh" or filetype == "zsh" then
                    -- SHELL
                    local absolute_path = vim.fn.expand("%:p")
                    local is_executable = require("user.functions").is_executable(absolute_path)
                    local chmod = is_executable and "" or string.format("chmod +x %s && ", head .. tail)
                    command = string.format("%s%s", chmod, head .. tail)
                end

                vim.cmd(string.format('TermExec go_back=0 cmd="%s"', command))
            end,
            desc = "Run File",
        },
    },
}

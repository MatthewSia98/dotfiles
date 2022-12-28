local F = {}

F.get_max_line_width = function(lines)
    if #lines == 0 then
        return -1
    end

    local max_width
    for _, line in ipairs(lines) do
        if not max_width or #line > max_width then
            max_width = #line
        end
    end

    return max_width
end

F.clear_buffer = function()
    vim.api.nvim_buf_set_lines(
        0, -- buffer handle
        0, -- start row (0-based, end exclusive)
        -1, -- end row (0-based, end exclusive)
        true, -- out of bounds indices are clamped to nearest valid value if false
        {} -- replacement lines    set to {} to delete lines
    )
end

F.create_floating = function(lines)
    if lines == nil then
        return
    end

    local max_width = F.get_max_line_width(lines)
    if max_width == -1 then
        return
    end

    local buf = vim.api.nvim_create_buf(
        false, -- sets buflisted
        true -- create throwaway scratch-buffer (sets nomodified and nomodeline) on buffer
    )
    vim.api.nvim_buf_set_lines(
        buf, -- buffer handle
        0, -- start row (0-based, end exclusive)
        -1, -- end row (0-based, end exclusive)
        true, -- out of bounds indices are clamped to nearest valid value if false
        lines and lines or {} -- replacement lines    set to {} to delete lines
    )

    local win = vim.api.nvim_open_win(
        buf, -- buffer handle
        true, -- enter window
        {
            relative = "editor", -- REQUIRED    'editor' | 'win' | 'cursor'
            -- win = 0,  -- window handle for relative = 'win'
            anchor = "NW", -- DEFAULT: 'NW'    'NW' | 'NE' | 'SW' | 'SE'    (0, 0) coordinate will be based on corner chosen
            width = max_width, -- window width in character cells
            height = #lines, -- window height in character cells
            -- bufpos = { 50, 50 },  -- DEFAULT: { 1, 0 } if anchor = 'NW' | 'NE', { 0, 0 } if anchor = 'SW' | 'SE'  place float relative to buffer text when relative = 'win'
            row = 1, -- row position in units of screen cell height
            col = 4, -- column position in units of screen cell width
            -- focusable = true,  -- DEFAULT: true    true | false    enable focus by user actions (wincmds, mouse). Non-focusable windows can be entered by nvim_set_current_win
            zindex = 50, -- DEFAULT: 50
            style = "minimal",
            border = "rounded", -- DEFAULT: 'none'    'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow' | { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }
            noautocmd = true, -- don't fire buffer autocommands (BufEnter, BufLeave, BufWinEnter)
        }
    )
    print("Created Buffer:", buf)
    -- optional: change highlight, otherwise Pmenu is used
    vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat")

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_hide(win)
    end, { buffer = buf })

    return win, buf
end

F.open_buf = function(buf)
    local lines = vim.api.nvim_buf_get_lines(
        buf, -- buffer handle
        0, -- start row (0-based, end exclusive)
        -1, -- end row (0-based, end exclusive)
        true -- out of bounds indices are clamped to nearest valid value if false
    )
    local max_width = F.get_max_line_width(lines)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor", -- REQUIRED    'editor' | 'win' | 'cursor'
        -- win = 0,  -- window handle for relative = 'win'
        anchor = "NW", -- DEFAULT: 'NW'    'NW' | 'NE' | 'SW' | 'SE'    (0, 0) coordinate will be based on corner chosen
        width = max_width, -- window width in character cells
        height = #lines, -- window height in character cells
        -- bufpos = { 50, 50 },  -- DEFAULT: { 1, 0 } if anchor = 'NW' | 'NE', { 0, 0 } if anchor = 'SW' | 'SE'  place float relative to buffer text when relative = 'win'
        row = 1, -- row position in units of screen cell height
        col = 4, -- column position in units of screen cell width
        -- focusable = true,  -- DEFAULT: true    true | false    enable focus by user actions (wincmds, mouse). Non-focusable windows can be entered by nvim_set_current_win
        zindex = 50, -- DEFAULT: 50
        style = "minimal",
        border = "rounded", -- DEFAULT: 'none'    'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow' | { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }
        noautocmd = true, -- don't fire buffer autocommands (BufEnter, BufLeave, BufWinEnter)
    })

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_hide(win)
    end, { buffer = buf })
end

F.get_visual_lines = function()
    local _, r1, _, _ = unpack(vim.fn.getpos("'<"))
    local _, r2, _, _ = unpack(vim.fn.getpos("'>"))
    local lines = vim.api.nvim_buf_get_lines(0, r1 - 1, r2, false)

    return lines, r1, r2
end

F.reverse_lines = function()
    local lines, r1, r2 = F.get_visual_lines()

    local reversed_lines = {}
    for i = #lines, 1, -1 do
        table.insert(reversed_lines, lines[i])
    end

    vim.api.nvim_buf_set_lines(0, r1 - 1, r2, false, reversed_lines)
end

F.get_cmd_output = function(cmd)
    vim.validate({
        cmd = { cmd, "string" },
    })

    local lines = {}
    vim.fn.jobstart(cmd, {
        on_stdout = function(_, data, _)
            lines = { unpack(data, 1, #data - 1) }
        end,
        stdout_buffered = true,
    })
    return lines
end

F.send_visual_lines_to_terminal = function()
    local filetype = vim.bo.filetype

    local t = require("toggleterm.terminal")
    if not vim.g.toggleterm_pid then
        -- local win = vim.api.nvim_get_current_win()
        t.get_or_create_term(t.get_toggled_id(), nil, nil):open(nil, nil)
        local term = t.get_all()[t.get_toggled_id()]
        local job = term.job_id
        local pid = vim.fn.jobpid(job)
        vim.g.toggleterm_pid = pid
        -- vim.api.nvim_set_current_win(win)
    else
        vim.g.toggleterm_pid = vim.fn.jobpid(t.get(1).job_id)
    end

    if filetype == "python" then
        local ipython =
            vim.fn.system("ps -f -u $USER | grep '" .. vim.g.toggleterm_pid .. ".*[i]python --no-autoindent'")
        if ipython == "" then
            vim.cmd('TermExec cmd="ipython --no-autoindent"')
        end
    end

    local lines = F.get_visual_lines()
    for _, line in ipairs(lines) do
        require("toggleterm").exec(line, 1, nil, nil, nil, true)
    end
    if lines[#lines]:sub(1, 1) == " " then
        require("toggleterm").exec("", 1, nil, nil, nil, true)
    end
end

F.get_current_file = function(opt)
    local cwd = vim.fn.getcwd()
    local filename = vim.fn.expand("%:t")
    local absolute_filepath = vim.fn.expand("%:p")
    local relative_filepath = vim.fn.expand("%:.")

    local res
    if opt == "absolute" then
        res = absolute_filepath
    elseif opt == "relative" then
        res = relative_filepath
    else
        res = filename
    end

    vim.notify("cwd:  " .. cwd .. "\nfile: " .. res, "info", { title = "Current File", timeout = 3000 })
    return res
end

F.is_executable = function(filepath)
    local perms = vim.fn.getfperm(filepath)
    return perms:sub(3, 3) == "x"
end

return F

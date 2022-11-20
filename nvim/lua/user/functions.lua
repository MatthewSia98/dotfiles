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

F.reverse_lines = function()
    local _, r1, _, _ = unpack(vim.fn.getpos("'<"))
    local _, r2, _, _ = unpack(vim.fn.getpos("'>"))
    local lines = vim.api.nvim_buf_get_lines(0, r1 - 1, r2, false)

    local reversed_lines = {}
    for i = #lines, 1, -1 do
        table.insert(reversed_lines, lines[i])
    end

    vim.api.nvim_buf_set_lines(0, r1 - 1, r2, false, reversed_lines)
end

return F

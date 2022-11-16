local installed, toggleterm = pcall(require, 'toggleterm')

if installed then
    toggleterm.setup {
        size = 40,
        direction = 'float',
        shell = '/bin/zsh',
        float_opts = {
            border = 'curved',
            width = 150,
            height = 32,
            winblend = 3,
        },
    }

    local keys = require('user.keymaps')
    keys.map('n', '<leader>tt', '<cmd>ToggleTerm<CR>')
    keys.map('n', '<leader>tr',
        function()
            local filetype = vim.bo.filetype
            local filepath = vim.fn.expand('%')
            local command
            if filetype == 'lua' then
                command = 'lua ' .. filepath
            elseif filetype == 'python' then
                command = 'python ' .. filepath
            elseif filetype == 'java' then
                local splits = vim.split(filepath, '/')
                local prefix = ''
                for i = 1, #splits - 1 do
                    prefix = prefix .. splits[i] .. '/'
                end
                command = 'javac ' .. filepath .. '; java -cp ' .. prefix .. ' ' .. splits[#splits]:gsub('.java', '')
            elseif filetype == 'sh' then
                command = 'chmod +x ' .. filepath .. '; ' .. filepath
            end
            -- local winwidth = vim.fn.winwidth(0)
            -- vim.cmd('TermExec size=' .. math.floor(winwidth / 3) .. ' cmd="' .. command .. '"')
            vim.cmd('TermExec cmd="' .. command .. '"')
        end, { desc = 'run file' }
    )
end

function P(item)
    print(vim.inspect(item))
end

function R(name)
    require('plenary.reload').reload_module(name)
    return require(name)
end

local function map(mode, key, value, options)
    options = options or { silent = true, noremap = true }
    vim.keymap.set(mode, key, value, options)
end

-- local function unmap(mode, key, options)
--     vim.keymap.del(mode, key, options)
-- end


-- VIM --
local g = vim.g
local o = vim.opt
local A = vim.api

g.python3_host_prog = '/usr/bin/python3'
-- cmd('syntax on')
-- A.nvim_command('filetype plugin indent on')

o.termguicolors = true
-- o.background = 'dark'

-- Do not save when switching buffers
-- o.hidden = true

vim.o.conceallevel = 2
vim.o.concealcursor = ''

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Enable mouse
o.mouse = 'a'

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 12

-- Better editor UI
o.number = true
o.numberwidth = 6
o.relativenumber = true
o.signcolumn = 'yes:1'
o.cursorline = true
-- Better editing experience
o.expandtab = true
-- o.smarttab = true
o.cindent = true
-- o.autoindent = true
o.wrap = false
o.textwidth = 127
o.tabstop = 4
o.shiftwidth = 0
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
o.listchars = 'lead:·,trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'
-- o.listchars = 'eol:↲,eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,'
-- o.formatoptions = 'qrn1'

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- Only 1 global statusline
o.laststatus = 3

-- Preserve view while jumping
-- o.jumpoptions = 'view'

-- BUG: this won't update the search count after pressing `n` or `N`
-- When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
-- o.lazyredraw = true

-- Code Folding
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
-- Don't fold by default
o.foldlevelstart = 99
o.foldnestmax = 3
o.foldminlines = 1

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '

-- AUTOCMD --
local group = A.nvim_create_augroup('MyAutocmds', { clear = true })
-- Format before save
-- A.nvim_create_autocmd('BufWritePre', {
--         group = group,
--         callback = function()
--             local bufnr = A.nvim_get_current_buf()
--             local lsp_client = vim.lsp.get_active_clients({ bufnr = bufnr })[1]
--
--             if lsp_client ~= nil and lsp_client['server_capabilities']['documentFormattingProvider'] then
--                 vim.lsp.buf.format()
--             end
--         end
--     }
-- )

-- Prevent newline from starting as comment
A.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function()
        -- t: Auto-wrap using textwidth
        -- c: Auto-wrap comments using textwidth and insert comment leader automatically
        -- r: BAD!!! Automatically insert comment leader when hitting <Enter> in Insert mode
        -- o: BAD!!! Automatically insert comment leader when hitting o/O in Normal mode
        -- n: Recognize numbered lists
        -- l: Long lines are not broken in insert mode
        -- j: Remove comment leader when joining lines
        -- p: Don't break lines at single spaces that follow periods e.g. Mr. John
        vim.cmd [[set formatoptions=tcnjp]]
    end
})

-- Highlight yanked region
A.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 3000 })
    end
})


-- PLUGINS --
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

-- My Plugins
Plug '~/.config/nvim/my-plugins/python-docstring-generator.nvim'

-- Icons
Plug 'kyazdani42/nvim-web-devicons'

-- Color Scheme
Plug('catppuccin/nvim', { as = 'catppuccin' })

-- Notifications
Plug 'rcarriga/nvim-notify'

-- Visualize RGB color codes
Plug 'norcalli/nvim-colorizer.lua'

-- Easily toggle and make new comments
Plug 'numToStr/Comment.nvim'

-- Easily surround text objects
-- Plug 'machakann/vim-sandwich'
Plug 'kylechui/nvim-surround'

-- Matching Quotes/Brackets
Plug 'windwp/nvim-autopairs'

-- Status Lines
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/lsp-status.nvim'

-- Indent Lines
Plug 'lukas-reineke/indent-blankline.nvim'

-- Smooth Scrolling
Plug 'karb94/neoscroll.nvim'

-- Git Decorations
Plug 'lewis6991/gitsigns.nvim'

-- Preview Git Commits
Plug 'rhysd/git-messenger.vim'

-- Directory Tree
Plug 'kyazdani42/nvim-tree.lua'

-- Run lua jobs
Plug 'nvim-lua/plenary.nvim'

-- Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

-- Abstract Syntax Tree
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = vim.fn[':TSUpdate'] })
Plug 'nvim-treesitter/playground'

-- Language Server
Plug 'neovim/nvim-lspconfig'

-- Language Server Manager
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

-- Plug 'jose-elias-alvarez/null-ls.nvim'

-- Pretty LSP Preview
Plug 'folke/trouble.nvim'

-- Luasnip
Plug 'L3MON4D3/LuaSnip'
-- Plug 'rafamadriz/friendly-snippets'

-- Code Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
-- Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'

-- Plug 'goerz/jupytext.vim'
-- Plug('dccsillag/magma-nvim', { ['do'] = vim.fn[':UpdateRemotePlugins'] })
vim.call('plug#end')


-- COLOR SCHEME --
local catppuccin = require('catppuccin')
local catppuccin_palette = require('catppuccin/palettes').get_palette()

vim.g.catppuccin_flavour = 'macchiato'
catppuccin.setup {
    transparent_background = false,
    integrations = {},
    custom_highlights = {
        Comment = { fg = catppuccin_palette.blue },
        LineNr = { fg = catppuccin_palette.lavender },
        CursorLineNr = { fg = '#00FFFF' }
    }
}
vim.cmd [[colorscheme catppuccin]]


-- NVIM NOTIFY --
local notify = require('notify')


-- -- BUFFERLINE --
local bufferline = require('bufferline')
bufferline.setup {
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        numbers = function(tbl)
            -- ordinal, id
            return tbl['id'] .. '.'
        end,
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- 'icon' | 'underline' | 'none',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
            return buf.name
        end,
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        tab_size = 18,
        diagnostics = 'nvim_lsp', -- false | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = true,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "("..count..")"
        end,
        offsets = {
            {
                filetype = "NvimTree",
                text = 'File Explorer', -- "File Explorer" | function ,
                text_align = 'left',
                separator = true,
            }
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = 'thick', -- "slant" | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' |
        -- 'tabs' | function(buffer_a, buffer_b)
        sort_by = 'insert_at_end',
    }
}

-- LSPSTATUS --
local lsp_status = require('lsp-status')
lsp_status.config({
    current_function = true,
    show_filename = true,
    diagnostics = false,
    status_symbol = '',
    component_separator = ' ',
    indicator_separator = ' ',
    indicator_errors = '',
    indicator_warnings = '',
    indicator_info = '',
    indicator_hint = '',
    indicator_ok = '',
    kind_labels = {}
})


-- LUALINE --
require('lualine').setup {
    options = {
        theme = 'catppuccin',
        icons_enabled = true,
        -- powerline    
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' }
    },
    -- a b c                x y z
    sections = {
        -- 'mode', 'branch', 'diff', 'diagnostics', 'filename', 'encoding', 'fileformat', 'filetype', 'progress', 'location'
        lualine_a = { 'mode', },
        lualine_b = { 'branch' },
        lualine_c = {
            { 'diagnostics',
                sources = { 'nvim_lsp' },
                sections = { 'error', 'warn', 'info', 'hint' },
                diagnostics_color = {
                    error = 'DiagnosticError',
                    warn  = 'DiagnosticWarn',
                    info  = 'DiagnosticInfo',
                    hint  = 'DiagnosticHint',
                },
                -- symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
                colored = true,
                update_in_insert = true,
                always_visible = false,
            },
            'require("lsp-status").status()'
        },
        lualine_x = {},
        lualine_y = { 'encoding', 'fileformat', },
        lualine_z = { 'progress', 'location' },
    },
    tabline = {},
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filename' }
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filename' }
    },
}


-- NVIMTREE --
local nvim_tree = require('nvim-tree')

map('n', '<leader>nt', '<cmd>NvimTreeToggle<CR>')

nvim_tree.setup {
    sort_by = 'case_sensitive',
    view = {
        adaptive_size = false,
        mappings = {
            list = {
                { key = 'u', action = 'dir_up' },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
}


-- TROUBLE --
local trouble = require('trouble')

map('n', '<leader>wd', '<cmd>TroubleToggle workspace_diagnostics<cr>')
map('n', '<leader>dd', '<cmd>TroubleToggle document_diagnostics<cr>')
map('n', '<leader>ll', '<cmd>TroubleToggle loclist<cr>')
map('n', '<leader>qf', '<cmd>TroubleToggle quickfix<cr>')

trouble.setup {
    position = 'bottom', -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = 'workspace_diagnostics', -- 'document_diagnostics', 'quickfix', 'lsp_references', 'loclist'
    fold_open = '', -- icon used for open folds
    fold_closed = '', -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = 'q', -- close the list
        cancel = '<esc>', -- cancel the preview and get back to your last window / buffer / cursor
        refresh = 'r', -- manually refresh
        jump = { '<cr>', '<tab>' }, -- jump to the diagnostic or open / close folds
        open_split = { '<c-x>' }, -- open buffer in new split
        open_vsplit = { '<c-v>' }, -- open buffer in new vsplit
        open_tab = { '<c-t>' }, -- open buffer in new tab
        jump_close = { 'o' }, -- jump to the diagnostic and close the list
        toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = 'P', -- toggle auto_preview
        hover = 'K', -- opens a small popup with the full multiline message
        preview = 'p', -- preview the diagnostic location
        close_folds = { 'zM', 'zm' }, -- close all folds
        open_folds = { 'zR', 'zr' }, -- open all folds
        toggle_fold = { 'zA', 'za' }, -- toggle fold of current file
        previous = 'k', -- preview item
        next = 'j' -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = true, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = { 'lsp_definitions', 'lsp_references' }, -- for the given modes, automatically jump if there is only a single result
    use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
    signs = {
        error = '',
        warning = '',
        hint = '',
        information = '',
        other = '﫠'
    },
}


-- TELESCOPE--
local telescope = require('telescope')
local trouble_telescope = require('trouble.providers.telescope')

map('n', '<leader>f/', '<cmd>Telescope find_files<CR>')
map('n', '<leader>ff', '<cmd>Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>fg', '<cmd>Telescope git_commits<CR>')
map('n', '<leader>fa', '<cmd>Telescope live_grep<CR>')
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>')
map('n', '<leader>fo', '<cmd>Telescope vim_options<CR>')

telescope.setup {
    defaults = {
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                width = 0.99,
                preview_width = 0.5,
                preview_cutoff = 0,
                prompt_position = 'top',
            },
        },
        mappings = {
            i = {
                ['<C-h>'] = 'which_key',
                ['<C-t>'] = trouble_telescope.open_with_trouble,
            },
            n = {
                ['<C-t>'] = trouble_telescope.open_with_trouble,
                ['q'] = 'close',
            }
        }
    },
    pickers = {
        find_files = {
            layout_config = {
                preview_width = 0.7,
            },
        },
        find_buffers = {
            layout_config = {
                preview_width = 0.7,
            },
        },
        live_grep = {
            layout_config = {
                preview_width = 0.7,
            },
        },
        git_commits = {
            layout_config = {
                preview_width = 0.5,
            },
        },
        current_buffer_fuzzy_find = {
            layout_config = {
                preview_width = 0.4,
            }
        },
    },
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {
                -- even more opts
            }
        },
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        }
    }
}
telescope.load_extension('ui-select')
telescope.load_extension('fzf')


-- TREESITTER --
require('nvim-treesitter.configs').setup {
    auto_install = true,
    endwise = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { 'python' },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
}


-- INDENT BLANKLINE --
vim.cmd [[highlight IndentBlanklineChar guifg=#B7BDF8 gui=nocombine]] -- color of indent lines
vim.cmd [[highlight IndentBlanklineContextChar guifg=#FF00FF gui=nocombine]] -- color of current context indent line (vertical line)
vim.cmd [[highlight IndentBlanklineContextStart guisp=#FF00FF gui=underline]] -- color of current context start (underline)
require('indent_blankline').setup {
    enabled = true,
    use_treesitter = false,
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = false,
}


-- NEOSCROLL --
require('neoscroll').setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = { '<C-u>', '<C-d>', '<C-f>', '<C-b>' },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil, -- Default easing function
    pre_hook = nil, -- Function to run before the scrolling animation starts
    post_hook = nil, -- Function to run after the scrolling animation ends
    performance_mode = false, -- Disable "Performance Mode" on all buffers.
})


-- GIT SIGNS --
require('gitsigns').setup {
    on_attach = function()
        local gs = package.loaded.gitsigns
        -- Navigation
        map('n', '<leader>hn',
            function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end,
            { expr = true }
        )
        map('n', '<leader>hp',
            function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end,
            { expr = true }
        )

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
    end,
    signs = {
        add = {
            hl = 'GitSignsAdd',
            text = '▎',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn'
        },
        change = {
            hl = 'GitSignsChange',
            text = '▎',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
        delete = {
            hl = 'GitSignsDelete',
            text = '',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            hl = 'GitSignsDelete',
            text = '',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },
}


-- GIT MESSENGER --
vim.g.git_messenger_no_default_mappings = true
vim.g.git_messenger_always_into_popup = false
map('n', '<leader>gm', '<cmd>GitMessenger<CR>')


-- COMMENT PLUGIN --
require('Comment').setup {
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
        line = 'gcc',
        block = 'gbc',
    },
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
    },
}


-- COLORIZER --
require('colorizer').setup()


-- NVIM SURROUND --
local nvim_surround = require('nvim-surround')

-- Line Text Objects
map({'o', 'x'}, 'il', ':<C-u>normal! ^v$<CR>')
map({'o', 'x'}, 'al', ':<C-u>normal! 0v$<CR>')

vim.cmd [[highlight default link NvimSurroundHighlight Visual]]

nvim_surround.setup()


-- MASON --
require('mason').setup {
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
        },
    }
}


-- MASON LSPCONFIG --
require('mason-lspconfig').setup()


-- NULL LS --
-- local null_ls = require('null-ls')
-- local null_ls_sources = {
--     null_ls.builtins.formatting.black,
--     null_ls.builtins.formatting.isort,
-- }
-- null_ls.setup({
--     sources =  null_ls_sources
-- })


-- LSP CONFIG --
local lspconfig = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Get LSP progress updates on status line
    lsp_status.on_attach(client)
    lsp_status.register_progress()

    if client['name'] == 'pylsp' then
        local env = vim.env.VIRTUAL_ENV or '/usr'
        print('Jedi Environment:', env)
    end

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', bufopts)
    map('n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', bufopts)
    map('n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>', bufopts)
    map('n', '<leader>dll', '<cmd>lua vim.diagnostic.setloclist()<CR>', bufopts)
    map('n', '<leader>dqf', '<cmd>lua vim.diagnostic.setqflist()<CR>', bufopts)
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', bufopts)
    map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
    -- map('n', '<leader>s', vim.lsp.buf.signature_help, bufopts)
    map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', bufopts)
    map({'n', 'v'}, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', bufopts)
    map('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>', bufopts)
    map('x', '<leader>fm', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', bufopts)
    map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', bufopts)
    map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', bufopts)
    map('n', '<leader>wls', function() P(vim.lsp.buf.list_workspace_folders()) end, bufopts)
end

local lsp_flags = {
    debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

local handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = true,
        signs = false,
        severity_sort = true,
    }),
    ['textDocument/definition'] = function (err, result, ctx, config)
        if err ~= nil then P(err) end
        local util = require('vim.lsp.util')
        if result == nil or vim.tbl_isempty(result) then
            notify('No definitions found', 'info', {
                title = 'LSP',
                timeout = 1000,
            })
        else
            -- textDocument/definition can return Location or Location[]
            -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition
            config = config or {}
            local client = vim.lsp.get_client_by_id(ctx.client_id)

            if vim.tbl_islist(result) then
              local title = 'LSP Definitions'
              local items = util.locations_to_items(result, client.offset_encoding)

                if #result == 1 then
                    util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
                    return
                else
                    vim.fn.setloclist(0, {}, ' ', { title = title, items = items })
                    vim.cmd [[Trouble loclist]]
                end
            else
                util.jump_to_location(result, client.offset_encoding, config.reuse_win)
            end
        end
    end,
    ['textDocument/references'] = function(err, result, ctx, config)
        if err ~= nil then P(err) end
        local util = require('vim.lsp.util')
        if not result or vim.tbl_isempty(result) then
            notify('No references found', 'info', {
                title = 'LSP',
                timeout = 1000,
            })
        else
            config = config or {}
            local client = vim.lsp.get_client_by_id(ctx.client_id)

              local title = 'LSP References'
              local items = util.locations_to_items(result, client.offset_encoding)

            if #result == 1 then
                notify('No other references', 'info', {
                    title = title,
                    timeout = 1000,
                })
            else
                vim.fn.setloclist(0, {}, ' ', { title = title, items = items, context = ctx })
                vim.cmd [[Trouble loclist]]
            end
        end
    end
}

-- SIGNS
-- vim.fn.sign_define(
--     'DiagnosticSignError',
--     { texthl = 'DiagnosticSignError', text = '', numhl = 'DiagnosticSignError' }
-- )
-- vim.fn.sign_define(
--     'DiagnosticSignWarn',
--     { texthl = 'DiagnosticSignWarn', text = '', numhl = 'DiagnosticSignWarn' }
-- )
-- vim.fn.sign_define(
--     'DiagnosticSignHint',
--     { texthl = 'DiagnosticSignHint', text = '', numhl = 'DiagnosticSignHint' }
-- )
-- vim.fn.sign_define(
--     'DiagnosticSignInfo',
--     { texthl = 'DiagnosticSignInfo', text = '', numhl = 'DiagnosticSignInfo' }
-- )
-- -- Create a custom namespace. This will aggregate signs from all other
-- -- namespaces and only show the one with the highest severity on a
-- -- given line
-- local ns = vim.api.nvim_create_namespace("my_namespace")
--
-- -- Get a reference to the original signs handler
-- local orig_signs_handler = vim.diagnostic.handlers.signs
--
-- -- Override the built-in signs handler
-- vim.diagnostic.handlers.signs = {
--     show = function(_, bufnr, _, opts)
--         -- Get all diagnostics from the whole buffer rather than just the
--         -- diagnostics passed to the handler
--         local diagnostics = vim.diagnostic.get(bufnr)
--
--         -- Find the "worst" diagnostic per line
--         local max_severity_per_line = {}
--         for _, d in pairs(diagnostics) do
--             local m = max_severity_per_line[d.lnum]
--             if not m or d.severity < m.severity then
--                 max_severity_per_line[d.lnum] = d
--             end
--         end
--
--         -- Pass the filtered diagnostics (with our custom namespace) to
--         -- the original handler
--         local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
--         orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
--     end,
--     hide = function(_, bufnr)
--         orig_signs_handler.hide(ns, bufnr)
--     end,
-- }

lspconfig['pylsp'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false, },
                pyflakes = { enabled = false, },
                mccabe = { enabled = false, },
                jedi = {
                    environment = vim.env.VIRTUAL_ENV or '/usr',
                },
                jedi_completion = {
                    enabled = true,
                    fuzzy = true,
                    eager = true,
                    resolve_at_most = 25,
                    cache_for = {'numpy', 'pandas', 'torch', 'matplotlib'}
                },
                jedi_definition = {
                    enabled = true,
                    follow_builtin_imports = true,
                    follow_imports = true,
                },
                jedi_hover = {
                    enabled = true,
                },
                jedi_references = {
                    enabled = true,
                },
                jedi_signature_help = {
                    enabled = true,
                },
                jedi_symbols = {
                    enabled = true,
                    all_scopes = true,
                    include_import_symbols = true,
                },
                flake8 = {
                    enabled = true,
                    ignore = {
                        'E501', -- Line too long
                        'E266', -- Too many leading # for block comment
                    }
                },
                pylint = {
                    enabled = false,
                    executable = 'pylint',
                },
                pylsp_black = {
                    enabled = true,
                    preview = true,
                    max_line_length = 88,
                },
                pylsp_mypy = {
                    enabled = true,
                    live_mode = true,
                    strict = false,
                },
                pylsp_rope = {
                    enabled = true,
                },
                pyls_isort = {
                    enabled = true,
                }
            }
        }
    }
}

-- JEDI --
-- lspconfig['jedi_language_server'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags,
--     handlers = handlers,
--     capabilities = capabilities,
-- }

-- PYRIGHT --
-- lspconfig['pyright'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags,
--     handlers = handlers,
--     capabilities = capabilities,
-- }

-- LUA LSP --
lspconfig['sumneko_lua'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    handlers = handlers,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
                workspaceDelay = -1,
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
                ignoreDir = {
                    'plugged',
                },
                useGitIgnore = true,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- JAVA LSP --
-- lspconfig['jdtls'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags,
--     handlers = handlers,
--     capabilities = capabilities,
-- }


-- LUASNIP --
local luasnip = require('luasnip')
local types = require('luasnip.util.types')
map({ 'i', 's' }, '<C-u>', '<cmd>lua require("luasnip.extras.select_choice")()<CR>')
map({ 'i', 's' }, '<C-l>', function() if luasnip.jumpable(1) then luasnip.jump(1) end end)
map({ 'i', 's' }, '<C-h>', function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end)
map({ 'i', 's' }, '<C-n>', '<Plug>luasnip-next-choice')
map({ 'i', 's' }, '<C-p>', '<Plug>luasnip-prev-choice')
-- Deleting insert node default puts you back in Normal mode
-- <C-G> changes to VISUAL, s clears and enters INSERT
map('s', '<BS>', '<C-G>s')

luasnip.config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { ' ﬋ Current Choice ', 'CmpItemKindFunction' } },
            },
        },
    }
}
-- require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_lua').lazy_load({
    paths = '~/.config/nvim/my-snippets'
})


-- NVIM CMP --
local cmp = require('cmp')
local lspkind = require('lspkind')

-- Scrollbar
vim.cmd [[highlight PmenuThumb guibg=#C5CDD9 guifg=NONE]]

-- Prompt Menu
vim.cmd [[highlight CmpPmenu guibg=#22252A guifg=#C5CDD9]]
vim.cmd [[highlight PmenuSel guibg=#6E738D guifg=NONE]]

-- Completion Items
vim.cmd [[highlight CmpItemAbbr guibg=NONE guifg=#CAD3F5]]
vim.cmd [[highlight CmpItemAbbrDeprecated guibg=NONE guifg=#FF0000 gui=strikethrough]]
vim.cmd [[highlight CmpItemAbbrMatch guibg=NONE guifg=#82AAFF gui=bold]]
vim.cmd [[highlight CmpItemAbbrMatchFuzzy guibg=NONE guifg=#82AAFF gui=bold]]
vim.cmd [[highlight CmpItemMenu guibg=NONE guifg=#C6A0F6 gui=NONE]]
vim.cmd [[highlight CmpItemKindField guibg=#B5585F guifg=#EED8DA]]
vim.cmd [[highlight CmpItemKindProperty guibg=#B5585F guifg=#EED8DA]]
vim.cmd [[highlight CmpItemKindEvent guibg=#B5585F guifg=#EED8DA]]
vim.cmd [[highlight CmpItemKindText guibg=#9FBD73 guifg=#FFFFFF]]
vim.cmd [[highlight CmpItemKindEnum guibg=#9FBD73 guifg=#FFFFFF]]
vim.cmd [[highlight CmpItemKindKeyword guibg=#9FBD73 guifg=#FFFFFF]]
vim.cmd [[highlight CmpItemKindConstant guibg=#D4BB6C guifg=#FFE082]]
vim.cmd [[highlight CmpItemKindConstructor guibg=#D4BB6C guifg=#FFE082]]
vim.cmd [[highlight CmpItemKindReference guibg=#D4BB6C guifg=#FFE082]]
vim.cmd [[highlight CmpItemKindFunction guibg=#A377BF guifg=#EADFF0]]
vim.cmd [[highlight CmpItemKindStruct guibg=#A377BF guifg=#EADFF0]]
vim.cmd [[highlight CmpItemKindClass guibg=#A377BF guifg=#EADFF0]]
vim.cmd [[highlight CmpItemKindModule guibg=#A377BF guifg=#EADFF0]]
vim.cmd [[highlight CmpItemKindOperator guibg=#A377BF guifg=#EADFF0]]
vim.cmd [[highlight CmpItemKindVariable guibg=#7E8294 guifg=#C5CDD9]]
vim.cmd [[highlight CmpItemKindFile guibg=#7E8294 guifg=#C5CDD9]]
vim.cmd [[highlight CmpItemKindUnit guibg=#D4A959 guifg=#F5EBD9]]
vim.cmd [[highlight CmpItemKindSnippet guibg=#D4A959 guifg=#F5EBD9]]
vim.cmd [[highlight CmpItemKindFolder guibg=#D4A959 guifg=#F5EBD9]]
vim.cmd [[highlight CmpItemKindMethod guibg=#6C8ED4 guifg=#DDE5F5]]
vim.cmd [[highlight CmpItemKindValue guibg=#6C8ED4 guifg=#DDE5F5]]
vim.cmd [[highlight CmpItemKindEnumMember guibg=#6C8ED4 guifg=#DDE5F5]]
vim.cmd [[highlight CmpItemKindInterface guibg=#58B5A8 guifg=#D8EEEB]]
vim.cmd [[highlight CmpItemKindColor guibg=#58B5A8 guifg=#D8EEEB]]
vim.cmd [[highlight CmpItemKindTypeParameter guibg=#58B5A8 guifg=#D8EEEB]]

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup {
    completion = {
        completeopt = 'menu,menuone,noselect'
    },
    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
            local kind = lspkind.cmp_format({
                mode = 'symbol_text', -- {'text', 'text_symbol', 'symbol', 'symbol_text'}
                preset = 'default',
                maxwidth = 50,
                menu = ({
                    buffer = '[Buffer]',
                    path = '[Path]',
                    nvim_lsp = '[LSP]',
                    luasnip = '[Snip]',
                    nvim_lua = '[Api]',
                    latex_symbols = '[Latex]'
                }),
                symbol_map = {
                    Text = '  ',
                    Method = '  ',
                    Function = '  ',
                    Constructor = '  ',
                    Field = '  ',
                    Variable = '  ',
                    Class = '  ',
                    Interface = '  ',
                    Module = '  ',
                    Property = '  ',
                    Unit = '  ',
                    Value = '  ',
                    Enum = '  ',
                    Keyword = '  ',
                    Snippet = '  ',
                    Color = '  ',
                    File = '  ',
                    Reference = '  ',
                    Folder = '  ',
                    EnumMember = '  ',
                    Constant = '  ',
                    Struct = '  ',
                    Event = '  ',
                    Operator = '  ',
                    TypeParameter = '  ',
                },
            })(entry, vim_item)
            local strings = vim.split(vim_item.kind, '%s+', { trimempty = true })
            kind.kind = ' ' .. string.format('[%s] %-13s', strings[1], strings[2]) .. ' '

            return kind
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = {
            winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenu,CursorLine:PmenuSel,Search:None',
            col_offset = -3,
            side_padding = 0,
        }
        -- documentation = cmp.config.window.bordered(),
    },
    view = {
        entries = {
            name = 'custom',
            selection_order = 'near_cursor'
        }
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Insert,
            select = false -- Auto accept first result if true
        }),
    }),
    sources = cmp.config.sources({
        -- Order Matters! OR explicitly set priority
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 5 },
    })
}


-- AUTOPAIRS --
local npairs = require('nvim-autopairs')
npairs.setup {
        check_ts = true,
        enable_check_bracket_line = true
}


-- MAGMA --
-- g.magma_automatically_open_output = true
-- g.magma_image_provider = 'ueberzug'
-- g.magma_cell_highlight_group = 'PmenuSel'
-- map('n', '<Leader>mi', '<cmd>MagmaInit<CR>')
-- map('n', '<Leader>mr', '<cmd>MagmaEvaluateLine<CR>')
-- map('x', '<Leader>mr', ':<C-u>MagmaEvaluateVisual<CR>')
-- map('n', '<Leader>mrr', '<cmd>MagmaReevaluateCell<CR>')
-- map('n', '<Leader>mo', '<cmd>MagmaShowOutput<CR>')
-- map('n', '<Leader>moo', '<cmd>MagmaEnterOutput<CR>')
-- map('n', '<Leader>mc', '<cmd>MagmaInterrupt<CR>')
-- map('n', '<Leader>mrs', '<cmd>MagmaRestart<CR>')
-- map('n', '<Leader>mrst', '<cmd>MagmaRestart!<CR>')
-- map('n', '<Leader>md', '<cmd>MagmaDelete<CR>')
-- map('n', '<Leader>mq', '<cmd>MagmaDeinit<CR>')


-- KEY BINDINGS --
-- Go to start and end of line
map('i', '<C-E>', '<Esc>A')
map('n', '<C-E>', 'A<Esc>')
map('i', '<C-A>', '<Esc>I')
map('n', '<C-A>', 'I<Esc>')

-- Insert blank lines
map('n', '<CR>', 'o<Esc>')
map('n', '<S-CR>', 'O<Esc>')

-- Move Lines
map('n', '<C-n>', '<cmd>move .+1<CR>')
map('n', '<C-p>', '<cmd>move .-2<CR>')

-- Window Splits
vim.cmd [[highlight WinSeparator guibg=NONE guifg=#B7BDF8]]
-- Close window
map('n', 'q', '<C-w>c')
-- Move between windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
-- Window Resize
map('n', '<Right>', '<C-w>5>')
map('n', '<Left>', '<C-w>5<')
map('n', '<Up>', '<C-w>1+')
map('n', '<Down>', '<C-w>1-')
-- Buffers
-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
map('n', '<C-b>l', '<cmd>BufferLineCycleNext<CR>')
map('n', '<C-b>h', '<cmd>BufferLineCyclePrev<CR>')

-- These commands will move the current buffer backwards or forwards in the bufferline
map('n', '<C-b>L', '<cmd>BufferLineMoveNext<CR>')
map('n', '<C-b>H', '<cmd>BufferLineMovePrev<CR>')
map('n', '<C-b>b', '<cmd>ls<CR><cmd>buffer<Space>')
map('n', '<C-b>c', '<cmd>bdelete<CR>')

-- Tabs
-- map('n', '<C-t>v', '<cmd>tabnew<CR>')
-- map('n', '<C-t>l', '<cmd>tabnext<CR>')
-- map('n', '<C-t>h', '<cmd>tabprev<CR>')
-- map('n', '<C-t>c', '<cmd>tabclose<CR>')

-- Folds
map('n', '<leader>fd', 'za')

-- Reload Config
map('n', '<F4>', '<cmd>source %<CR>')

-- Terminal Mode
map('t', '<Esc>', '<C-\\><C-n>')



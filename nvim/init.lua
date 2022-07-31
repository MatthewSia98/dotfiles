local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug('preservim/nerdtree', {on = {'NERDTreeToggle'}})
Plug('nvim-lualine/lualine.nvim')
Plug('kyazdani42/nvim-web-devicons')
Plug('catppuccin/nvim', {as = 'catppuccin'})
vim.call('plug#end')

vim.g.catppuccin_flavour = 'macchiato'
local cp = require('catppuccin/palettes').get_palette()
require('catppuccin').setup({
                                transparent_background = false,
                                integrations = {},
                                custom_highlights = {
                                                        Comment = {fg = cp.blue},
                                                        LineNr = {fg = cp.lavender},
                                                        CursorLineNr = {fg = '#00FFFF'}
                                                    }
                            }
                           )
vim.cmd [[colorscheme catppuccin]]

require('lualine').setup({
                             options = {
                                           theme = 'catppuccin',
                                           icons_enabled = true,
                                           -- powerline    
                                           section_separators = {left = '', right = ''},
                                           component_separators = {left = '', right = ''}
                                       },
                             -- a b c                x y z
                             sections = {
                                            lualine_a = {'mode'},
                                            lualine_b = {}, --'branch', --'diagnostics'
                                            lualine_c = {'filename'},
                                            lualine_x = {'encoding', 'fileformat', 'filetype'},
                                            lualine_y = {}, --'branch', 'diff'}
                                            lualine_z = {'progress', 'location'}
                                        }
                         }
                        )

local g = vim.g
local o = vim.o

-- cmd('syntax on')
-- vim.api.nvim_command('filetype plugin indent on')

o.termguicolors = true
-- o.background = 'dark'

-- Do not save when switching buffers
-- o.hidden = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.numberwidth = 6
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true

-- Better editing experience
o.expandtab = true
-- o.smarttab = true
o.cindent = true
-- o.autoindent = true
o.wrap = true
o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 0
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'
-- o.listchars = 'eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,'
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

-- Preserve view while jumping
-- o.jumpoptions = 'view'

-- BUG: this won't update the search count after pressing `n` or `N`
-- When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
-- o.lazyredraw = true

-- Better folds (don't fold by default)
-- o.foldmethod = 'indent'
-- o.foldlevelstart = 99
-- o.foldnestmax = 3
-- o.foldminlines = 1

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '


-- KEY BINDINGS --
local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

--  mode   key      value
map('i', '<C-E>', '<Esc>A')
map('i', '<C-A>', '<Esc>E')
map('n', '<CR>', 'o<Esc>')
map('n', 'S-CR>', 'O<Esc>')

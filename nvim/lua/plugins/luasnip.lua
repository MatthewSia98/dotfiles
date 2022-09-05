local luasnip = require('luasnip')
local types = require('luasnip.util.types')

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

map({ 'i', 's' }, '<C-u>', '<cmd>lua require("luasnip.extras.select_choice")()<CR>')
map({ 'i', 's' }, '<C-l>', function() if luasnip.jumpable(1) then luasnip.jump(1) end end)
map({ 'i', 's' }, '<C-h>', function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end)
map({ 'i', 's' }, '<C-n>', '<Plug>luasnip-next-choice')
map({ 'i', 's' }, '<C-p>', '<Plug>luasnip-prev-choice')
-- Deleting insert node default puts you back in Normal mode
-- <C-G> changes to VISUAL, s clears and enters INSERT
map('s', '<BS>', '<C-G>s')

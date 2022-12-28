local installed, notify = pcall(require, "notify")

if installed then
    notify.setup({
        background_colour = require("catppuccin.palettes").get_palette().base,
        timeout = 3000,
        max_width = function()
            return math.floor(vim.o.columns * 0.4)
        end,
        max_height = function()
            return math.floor(vim.o.lines * 0.8)
        end,
    })
    vim.notify = notify
end

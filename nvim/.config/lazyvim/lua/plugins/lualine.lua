return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            disabled_filetypes = {
                winbar = { "trouble", "neo-tree" },
            },
        },
        winbar = {
            lualine_a = { "buffers" },
        },
    },
}

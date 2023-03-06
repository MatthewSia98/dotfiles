return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
        require("indent_blankline").setup({
            show_first_indent_level = false,
            char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
                "IndentBlanklineIndent3",
                "IndentBlanklineIndent4",
                "IndentBlanklineIndent5",
                "IndentBlanklineIndent6",
            },
        })
    end,
}

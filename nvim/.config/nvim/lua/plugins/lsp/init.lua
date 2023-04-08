return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugins.lsp.config")
            require("plugins.lsp.neodev")
            require("plugins.lsp.mason")
            require("plugins.lsp.mason_lspconfig")
            require("plugins.lsp.nvim_lspconfig")
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugins.lsp.null_ls")
        end,
    },
    {
        "glepnir/lspsaga.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "Lspsaga",
        enabled = require("config").lsp.goto_provider == "lspsaga"
            or require("config").lsp.actions_provider == "lspsaga",
        config = function()
            require("plugins.lsp.lspsaga")
        end,
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("plugins.lsp.navic")
        end,
    },
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Navbuddy",
        config = function()
            require("plugins.lsp.navbuddy")
        end,
        keys = {
            { "<leader>nb", "<CMD>Navbuddy<CR>", desc = "" },
        },
    },
}

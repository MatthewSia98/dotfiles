local installed, null_ls = pcall(require, "null-ls")

if installed then
    null_ls.setup({
        sources = {
            -- PYTHON --
            -- Diagnostics
            -- null_ls.builtins.diagnostics.flake8,
            -- null_ls.builtins.diagnostics.mypy,
            -- null_ls.builtins.diagnostics.pydocstyle,
            -- Formatting
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.isort,

            -- LUA --
            -- Diagnostics
            -- null_ls.builtins.diagnostics.luacheck,
            -- Formatting
            null_ls.builtins.formatting.stylua,

            -- JAVA --
            -- Formatting
            -- null_ls.builtins.formatting.google_java_format,

            -- GO --
            null_ls.builtins.formatting.gofumpt,

            -- RUST --
            null_ls.builtins.formatting.rustfmt,

            -- C --
            null_ls.builtins.formatting.clang_format,
        },
        border = "rounded",
        diagnostics_format = "#{m}",
    })
end

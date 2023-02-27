return {
    {
        "mfussenegger/nvim-dap",
        enabled = false,
        dependencies = {
            "rcarriga/nvim-dap-ui",
        },
        init = function()
            vim.g.dap_available_adapters = { "python" }

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "■", texthl = "DapStopped", linehl = "debugPC", numhl = "" })
        end,
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            dap.adapters.python = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
            }
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                            return cwd .. "/venv/bin/python"
                        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                            return cwd .. "/.venv/bin/python"
                        else
                            return "/usr/bin/python"
                        end
                    end,
                },
            }

            vim.g.dap_available_adapters = vim.tbl_keys(dap.adapters)
        end,
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>dq",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate",
            },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        enabled = false,
        config = function()
            require("dapui").setup({})

            local map = require("keymaps").map
            map("n", "<leader>dt", function()
                require("dapui").toggle()
            end, { desc = "Toggle DAP UI" })
        end,
    },
}

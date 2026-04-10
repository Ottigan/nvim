return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mason-org/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "leoluz/nvim-dap-go",
        -- Inline variable values as virtual text while stepping
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                highlight_changed_variables = true,
                highlight_new_as_changed = true,
                show_stop_reason = true,
                virt_text_pos = "eol",
            },
        },
    },
    keys = {
        {
            "<F1>",
            function()
                require("dap").continue()
            end,
            desc = "Debug: Start/Continue",
        },
        {
            "<F2>",
            function()
                require("dap").step_into()
            end,
            desc = "Debug: Step Into",
        },
        {
            "<F3>",
            function()
                require("dap").step_over()
            end,
            desc = "Debug: Step Over",
        },
        {
            "<F4>",
            function()
                require("dap").step_out()
            end,
            desc = "Debug: Step Out",
        },
        {
            "<F5>",
            function()
                require("dap").step_back()
            end,
            desc = "Debug: Step Back",
        },
        {
            "<leader>db",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "[D]ebug Toggle [B]reakpoint",
        },
        {
            "<leader>dB",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "[D]ebug Set Conditional [B]reakpoint",
        },
        {
            "<leader>dh",
            function()
                require("dap.ui.widgets").hover()
            end,
            desc = "[D]ebug [H]over value",
        },
        {
            "<leader>de",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").expression)
            end,
            desc = "[D]ebug [E]valuate expression",
        },
        {
            "<leader>ds",
            function()
                require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
            end,
            desc = "[D]ebug [S]copes",
        },
        {
            "<F7>",
            function()
                require("dapui").toggle()
            end,
            desc = "Debug: Toggle UI",
        },
    },
    config = function()
        local dap = require("dap")

        require("mason-nvim-dap").setup({
            automatic_installation = true,
            handlers = {},
            ensure_installed = {
                "delve",
                "js-debug-adapter",
            },
        })

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "::1",
            port = "${port}",
            executable = {
                command = "js-debug-adapter",
                args = {
                    "${port}",
                },
            },
        }

        -- ── Go ────────────────────────────────────────────────────────────────
        require("dap-go").setup()

        -- ── DAP UI ────────────────────────────────────────────────────────────
        local dapui = require("dapui")
        dapui.setup()

        -- Change breakpoint icons
        vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
        vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
        local breakpoint_icons = {
            Breakpoint = "●",
            BreakpointCondition = "⊜",
            BreakpointRejected = "⊘",
            LogPoint = "◆",
            Stopped = "⭔",
        }

        for type, icon in pairs(breakpoint_icons) do
            local tp = "Dap" .. type
            local hl = (type == "Stopped") and "DapStop" or "DapBreak"
            vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        end

        dap.listeners.before.attach.dapui_config = function()
            vim.schedule(dapui.open)
        end
        dap.listeners.before.launch.dapui_config = function()
            vim.schedule(dapui.open)
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
}

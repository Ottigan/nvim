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
            "<F5>",
            function()
                require("dap").continue()
            end,
            desc = "Debug: Start/Continue",
        },
        {
            "<F1>",
            function()
                require("dap").step_into()
            end,
            desc = "Debug: Step Into",
        },
        {
            "<F2>",
            function()
                require("dap").step_over()
            end,
            desc = "Debug: Step Over",
        },
        {
            "<F3>",
            function()
                require("dap").step_out()
            end,
            desc = "Debug: Step Out",
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
        local dapui = require("dapui")
        local dapui_icons = {
            expanded = "▾",
            collapsed = "▸",
            current_frame = "→",
        }
        local dapui_control_icons = {
            pause = "⏸",
            play = "⏵",
            step_into = "↓",
            step_over = "→",
            step_out = "↑",
            step_back = "←",
            run_last = "⟳",
            terminate = "⏹",
            disconnect = "⏏",
        }

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

        -- ── DAP UI ────────────────────────────────────────────────────────────
        dapui.setup({
            icons = dapui_icons,
            controls = {
                icons = dapui_control_icons,
            },
        })

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

        dap.listeners.after.event_initialized["dapui_config"] = function()
            vim.g.dap_suppress_close = false
            dapui.open()
        end

        -- on_session fires exactly once when a session truly ends (via Session:close()),
        -- unlike event_terminated which fires for intermediate subprocess events and
        -- always fires before any restart on_done callback makes a new session visible.
        -- When vim.g.dap_suppress_close is set (by run_last / debug-nearest keymaps),
        -- the close is skipped so the existing layout stays up through the restart.
        dap.listeners.on_session["dapui_config"] = function(old_session, new_session)
            if old_session ~= nil and new_session == nil and not vim.g.dap_suppress_close then
                dapui.close()
            end
        end

        -- nvim-dap recycles terminal buffers via an internal pool. When a session ends
        -- the buffer (with its old content) goes back into the pool; the next launch
        -- tries to call termopen() on it and fails with "requires unmodified buffer".
        --
        -- on_config fires after the old session has terminated (and its terminal job has
        -- exited, releasing the buffer back to the pool) but before the new session
        -- connects and sends runInTerminal. Deleting stale dap terminal buffers here
        -- forces nvim-dap to allocate a fresh buffer instead of reusing a dirty one.
        dap.listeners.on_config["cleanup_dap_terminals"] = function(config)
            local stale_bufs = {}

            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr]["dap-type"] ~= nil then
                    table.insert(stale_bufs, bufnr)
                end
            end

            if #stale_bufs > 0 then
                -- Close dapui first so its layout releases window references cleanly.
                -- Without this, deleting the terminal buffer closes its window and leaves
                -- dapui holding stale window IDs, causing "Invalid window id" errors when
                -- it tries to resize on the next event_initialized.
                pcall(dapui.close)
                for _, bufnr in ipairs(stale_bufs) do
                    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
                end
            end

            return config
        end

        -- ── Go ────────────────────────────────────────────────────────────────
        require("dap-go").setup({
            delve = {
                detached = vim.fn.has("win32") == 0,
            },
        })
    end,
}

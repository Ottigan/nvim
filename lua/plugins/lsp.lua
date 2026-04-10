return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    window = {
                        winblend = 0,
                        normal_hl = "Comment",
                    },
                },
            },
        },
        "saghen/blink.cmp",
        { "b0o/schemastore.nvim", lazy = true },
    },
    config = function()
        vim.filetype.add({
            extension = {
                pcss = "scss",
            },
        })

        vim.diagnostic.config({
            update_in_insert = false,
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            virtual_text = true,
            virtual_lines = false,
        })

        vim.keymap.set("n", "<leader>xe", vim.diagnostic.open_float, { desc = "Show Diagnostic [E]rror" })
        vim.keymap.set("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfi[x] List" })
        vim.keymap.set("n", "<leader>xc", function()
            vim.fn.setqflist({})
        end, { desc = "[C]lear Diagnostic Quickfix List" })
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1 })
        end, { desc = "Previous [D]iagnostic" })
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1 })
        end, { desc = "Next [D]iagnostic" })
        vim.keymap.set("n", "[e", function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Previous [E]rror" })
        vim.keymap.set("n", "]e", function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Next [E]rror" })

        -- Augroups created once; autocmds inside are buffer-scoped to avoid accumulation.
        local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = true })
        local detach_augroup = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                local builtin = require("telescope.builtin")
                map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
                map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
                map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("grr", builtin.lsp_references, "[G]oto [R]eferences")
                map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
                map("grx", vim.lsp.codelens.run, "Code Lens E[x]ecute")
                map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
                map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                map("gO", builtin.lsp_document_symbols, "Document Symbols")
                map("gW", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method("textDocument/documentHighlight", event.buf) then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = detach_augroup,
                        buffer = event.buf,
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
                        end,
                    })
                end

                if client and client.name == "ts_ls" then
                    -- Buffer-specific augroup: clear=true removes stale autocmds on re-attach.
                    local augroup = vim.api.nvim_create_augroup("ts-auto-import-" .. event.buf, { clear = true })

                    local function execute_code_action(action_kind)
                        ---@type lsp.CodeActionParams
                        local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
                        params.context = { only = { action_kind }, diagnostics = {} }

                        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                        if not result then
                            return
                        end

                        for _, res in pairs(result) do
                            for _, action in pairs(res.result or {}) do
                                if action.edit then
                                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                                elseif action.command then
                                    client:exec_cmd(action.command, { bufnr = event.buf })
                                end
                            end
                        end
                    end

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = event.buf,
                        group = augroup,
                        callback = function()
                            execute_code_action("source.addMissingImports.ts")
                            execute_code_action("source.removeUnusedImports.ts")

                            require("conform").format({
                                bufnr = vim.api.nvim_get_current_buf(),
                                timeout_ms = 500,
                                lsp_format = "fallback",
                            })
                        end,
                    })
                end
            end,
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local servers = {
            ts_ls = {
                init_options = {
                    preferences = {
                        autoImportFileExcludePatterns = { "react-redux" },
                    },
                },
            },
            gopls = {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            },
            lua_ls = {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if
                            path ~= vim.fn.stdpath("config")
                            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                        then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            version = "LuaJIT",
                            path = { "lua/?.lua", "lua/?/init.lua" },
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    })
                end,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "inject-field" },
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            },
            cssls = {
                filetypes = { "css", "scss", "less" },
                settings = {
                    css = { validate = true },
                    scss = { validate = true },
                    less = { validate = true },
                },
            },
            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },
        }

        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers or {}),
        })

        for name, server in pairs(servers) do
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            vim.lsp.config(name, server)
            vim.lsp.enable(name)
        end
    end,
}

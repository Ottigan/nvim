local function create_lsp_augroups()
    return {
        attach = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        highlight = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = true }),
        detach = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
    }
end

local function setup_filetypes()
    vim.filetype.add({
        extension = {
            pcss = "scss",
        },
    })
end

local function setup_diagnostics()
    vim.diagnostic.config({
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = true,
        virtual_lines = false,
    })
end

local function setup_lsp_keymaps()
    local builtin = require("telescope.builtin")

    local keymaps = {
        {
            keys = "gra",
            callback = vim.lsp.buf.code_action,
            desc = "Goto Code [A]ction",
            mode = { "n", "x" },
        },
        { keys = "gri", callback = builtin.lsp_implementations, desc = "Goto [I]mplementation" },
        { keys = "grn", callback = vim.lsp.buf.rename, desc = "Re[n]ame" },
        { keys = "grr", callback = builtin.lsp_references, desc = "Goto [R]eferences" },
        { keys = "grt", callback = builtin.lsp_type_definitions, desc = "Goto [T]ype Definition" },
        { keys = "grx", callback = vim.lsp.codelens.run, desc = "Code Lens E[x]ecute" },
        { keys = "grd", callback = builtin.lsp_definitions, desc = "Goto [D]efinition" },
        { keys = "grD", callback = vim.lsp.buf.declaration, desc = "Goto [D]eclaration" },
        { keys = "gO", callback = builtin.lsp_document_symbols, desc = "Document Symbols" },
        { keys = "gW", callback = builtin.lsp_dynamic_workspace_symbols, desc = "Workspace Symbols" },
    }

    for _, mapping in ipairs(keymaps) do
        vim.keymap.set(mapping.mode or "n", mapping.keys, mapping.callback, {
            desc = "LSP: " .. mapping.desc,
        })
    end
end

local function setup_servers()
    local servers = {
        just = {
            cmd = { "just-lsp" },
        },
        ts_ls = {
            cmd = { "typescript-language-server", "--stdio" },
            init_options = {
                preferences = {
                    autoImportFileExcludePatterns = { "react-redux" },
                },
            },
        },
        gopls = {
            cmd = { "gopls" },
            root_markers = { "go.mod" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            settings = {
                gopls = {
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                },
            },
        },
        lua_ls = {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            root_markers = { ".luarc.json", ".luarc.jsonc" },
            -- NOTE: These will be merged with the configuration file.
            settings = {
                Lua = {
                    -- Using stylua for formatting.
                    format = { enable = false },
                    hint = {
                        enable = true,
                        arrayIndex = "Disable",
                    },
                    runtime = {
                        version = "LuaJIT",
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                        },
                    },
                },
            },
        },
        cssls = {
            cmd = { "vscode-css-language-server", "--stdio" },
            filetypes = { "css", "scss", "less" },
            settings = {
                css = { validate = true },
                scss = { validate = true },
                less = { validate = true },
            },
        },
        jsonls = {
            cmd = { "vscode-json-language-server", "--stdio" },
            filetypes = { "json", "jsonc" },
            settings = {
                json = {
                    validate = { enable = true },
                    schemas = require("schemastore").json.schemas(),
                },
            },
        },
    }

    require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })

    for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
    end
end

local function setup_document_highlight(client, bufnr, groups)
    if not client:supports_method("textDocument/documentHighlight", bufnr) then
        return
    end

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = groups.highlight,
        callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = groups.highlight,
        callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
        buffer = bufnr,
        group = groups.detach,
        callback = function(event)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = groups.highlight, buffer = event.buf })
        end,
    })
end

local function setup_ts_ls_autocmds(client, bufnr)
    local function execute_code_action(action_kind)
        ---@type lsp.CodeActionParams
        local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
        params.context = { only = { action_kind }, diagnostics = {} }

        local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
        if not result then
            return
        end

        for _, res in pairs(result) do
            for _, action in pairs(res.result or {}) do
                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                elseif action.command then
                    client:exec_cmd(action.command, { bufnr = bufnr })
                end
            end
        end
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = vim.api.nvim_create_augroup("ts-import-" .. bufnr, { clear = true }),
        callback = function()
            execute_code_action("source.addMissingImports.ts")
            execute_code_action("source.removeUnusedImports.ts")

            vim.schedule(function()
                require("conform").format({
                    bufnr = bufnr,
                    timeout_ms = 3000,
                    lsp_format = "fallback",
                    async = true,
                })
            end)
        end,
    })
end

local function on_lsp_attach(event, groups)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then
        return
    end

    setup_document_highlight(client, event.buf, groups)

    if client.name == "ts_ls" then
        setup_ts_ls_autocmds(client, event.buf)
    end
end

return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        { "b0o/schemastore.nvim", lazy = true },
    },
    config = function()
        local groups = create_lsp_augroups()

        setup_filetypes()
        setup_diagnostics()
        setup_lsp_keymaps()
        setup_servers()

        vim.api.nvim_create_autocmd("LspAttach", {
            group = groups.attach,
            callback = function(event)
                on_lsp_attach(event, groups)
            end,
        })
    end,
}

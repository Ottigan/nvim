return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true })
            end,
            mode = { "n", "v" },
            desc = "[F]ormat buffer",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            scss = { "stylelint" },
        },

        default_format_opts = {
            lsp_format = "fallback",
        },

        format_on_save = function(bufnr)
            -- Disable for TypeScript/JavaScript - handled manually in ts_ls autocmd
            local disable_filetypes = {
                "typescript",
                "javascript",
                "typescriptreact",
                "javascriptreact",
            }

            if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
                return
            end

            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
    },
}

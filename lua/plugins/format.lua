local FORMAT_OPTIONS = {
    timeout_ms = 3000,
    async = true,
    lsp_format = "fallback",
}

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format(FORMAT_OPTIONS)
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }

            -- Disable for TypeScript/JavaScript - handled manually in ts_ls autocmd
            local ts_filetypes = {
                typescript = true,
                javascript = true,
                typescriptreact = true,
                javascriptreact = true,
            }

            if disable_filetypes[vim.bo[bufnr].filetype] or ts_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return FORMAT_OPTIONS
            end
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            scss = { "stylelint" },

            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
        },
    },
}

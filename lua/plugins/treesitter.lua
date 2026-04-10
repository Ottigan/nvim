return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local languages = {
            "lua",
            "javascript",
            "typescript",
            "tsx",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "templ",
            "html",
            "css",
            "scss",
            "json",
            "yaml",
            "markdown",
            "bash",
        }

        require("nvim-treesitter").install(languages)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = languages,
            callback = function()
                vim.treesitter.start()
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- folds
                vim.wo.foldmethod = "expr"
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
            end,
        })
    end,
}

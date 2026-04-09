return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy", -- Load after UI is ready
    build = ":TSUpdate",
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                "lua",
                "javascript",
                "typescript",
                "tsx",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "templ",
            },
            callback = function()
                vim.treesitter.start()                                            -- highlighting
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'               -- folds
                vim.wo.foldmethod = 'expr'
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
            end,
        })
    end,
}

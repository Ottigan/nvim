return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.config").setup({
            auto_install = true,
            ensure_installed = {
                "javascript",
                "typescript",
                "tsx",
            },
        })
    end,
}

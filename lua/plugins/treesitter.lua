return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        vim.notify("treesitter config running")
        require("nvim-treesitter.config").setup({
            ensure_installed = {},
        })
    end,
}

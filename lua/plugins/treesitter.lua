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
            -- Enable syntax highlighting
            highlight = {
                enable = true,
                -- Optional: disable highlighting for some languages
                -- disable = { "latex" },
            },
        })
    end,
}

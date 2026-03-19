return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        -- LazyVim will automatically handle lazy-loading
        keys = {
            { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
            { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff" },
            { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
            { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log" },
        },
    },
}

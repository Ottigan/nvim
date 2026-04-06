return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        keys = {
            { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
            { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff" },
            { "<leader>gv", "<cmd>Gvdiffsplit!<cr>", desc = "Git Vertical Diff" },
            { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
            { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log" },
            { "<leader>gh", "<cmd>diffget //2<cr>", desc = "Git Diff Get Left" },
            { "<leader>gl", "<cmd>diffget //3<cr>", desc = "Git Diff Get Right" },
        },
    },
}

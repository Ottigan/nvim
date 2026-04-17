-- lazy.nvim
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        image = { enabled = true },
        quickfile = { enabled = true },
        notifier = { enabled = true },
    },
    keys = {
        {
            "<leader>nh",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "[N]otification [H]istory",
        },
    },
}

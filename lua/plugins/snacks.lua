-- lazy.nvim
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        image = { enabled = true },
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        bufdelete = { enabled = true },
        rename = { enabled = true },
        indent = { enabled = true },
        notifier = { enabled = true },
        words = { enabled = false },
    },
    keys = {
        { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
    },
}

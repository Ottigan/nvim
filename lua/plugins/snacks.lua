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
        lazygit = {
            -- automatically configure lazygit to use the current colorscheme
            -- and integrate edit with the current neovim instance
            configure = true,
            -- extra configuration for lazygit that will be merged with the default
            -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
            -- you need to double quote it: `"\"test\""`
            config = {
                os = { editPreset = "nvim-remote" },
            },
            theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
        },
    },
    keys = {
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<leader>ss",
            function()
                Snacks.scratch.select()
            end,
            desc = "[S]elect [S]cratch Buffer",
        },
        {
            "<leader>n",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "Notification History",
        },
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },
        {
            "<leader>gl",
            function()
                Snacks.lazygit.log()
            end,
            desc = "Lazygit Log",
        },
        {
            "<leader>gf",
            function()
                Snacks.lazygit.log_file()
            end,
            desc = "Lazygit Log File",
        },
    },
}

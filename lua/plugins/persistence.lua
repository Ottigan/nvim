-- Session management
-- https://github.com/folke/persistence.nvim

return {
    "folke/persistence.nvim",
    event = "VimEnter", -- Fires for both files and directories
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
    },
    config = function()
        require("persistence").setup()
        vim.schedule(function()
            require("persistence").load()
        end)
    end,
    keys = {
        {
            "<leader>qs",
            function()
                require("persistence").load()
            end,
            desc = "Restore [S]ession for CWD",
        },
        {
            "<leader>qS",
            function()
                require("persistence").select()
            end,
            desc = "[S]elect Session to Restore",
        },
        {
            "<leader>ql",
            function()
                require("persistence").load({ last = true })
            end,
            desc = "Restore [L]ast Session",
        },
        {
            "<leader>qw",
            function()
                require("persistence").save()
            end,
            desc = "Save [W]orkspace Session",
        },
        {
            "<leader>qd",
            function()
                require("persistence").stop()
            end,
            desc = "[D]on't Save on Exit",
        },
    },
}

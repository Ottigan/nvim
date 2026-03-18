-- Session management
-- https://github.com/folke/persistence.nvim

return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
        need = 1,
        branch = false,
        options = { "buffers", "curdir", "tabpages", "winsize" },
        pre_save = function()
            -- Close neo-tree before saving session
            vim.cmd("Neotree close")
        end,
    },
    config = function(_, opts)
        require("persistence").setup(opts)
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

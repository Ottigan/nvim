-- Session management
-- https://github.com/folke/persistence.nvim

return {
    "folke/persistence.nvim",
    event = "VimEnter", -- Fires for both files and directories
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
        need = 1,
        branch = false,
    },
    config = function()
        require("persistence").setup()

        vim.schedule(function()
            -- Check if we're opening a directory or have no arguments
            local should_load = true

            if vim.fn.argc() > 0 then
                local first_arg = vim.fn.argv()[1]
                -- Check if the first argument is a file (not a directory)
                if vim.fn.isdirectory(first_arg) == 0 then
                    -- It's a file, don't load or save session
                    should_load = false
                    require("persistence").stop()
                end
            end

            -- Only load session if no file was passed as argument
            if should_load then
                require("persistence").load()
            end
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

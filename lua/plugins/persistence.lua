-- Session management
-- https://github.com/folke/persistence.nvim

return {
    "folke/persistence.nvim",
    event = "VimEnter", -- Fires for both files and directories
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
        need = 1,
        branch = true,
    },
    config = function(_, opts)
        require("persistence").setup(opts)

        local group = vim.api.nvim_create_augroup('PersistenceSession', { clear = true })
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = "PersistenceSavePre",
            callback = function()
                for _, id in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(id) then
                        local name = vim.api.nvim_buf_get_name(id)
                        local patterns = { "lazygit" }

                        local should_delete = false
                        for _, pattern in ipairs(patterns) do
                            if string.find(name, pattern) then
                                should_delete = true
                                break
                            end
                        end

                        if should_delete then
                            vim.bo[id].buflisted = false
                            vim.api.nvim_buf_delete(id, { force = true })
                        end
                    end
                end
            end
        })

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

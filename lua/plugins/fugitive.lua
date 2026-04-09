return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        keys = {
            {
                "<leader>gs",
                function()
                    vim.cmd("vertical Git")
                    vim.cmd("vertical resize 40")
                end,
                desc = "Git Status",
            },
            {
                "<leader>gq",
                function()
                    local buffers = {}
                    local removed_diff_name = ""

                    -- Delete all Fugitive buffers except main
                    for _, id in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_loaded(id) then
                            local name = vim.api.nvim_buf_get_name(id)

                            if vim.startswith(name, "fugitive:") and not vim.endswith(name, "//") then
                                vim.bo.buflisted = false
                                vim.api.nvim_buf_delete(id, { unload = true })
                                removed_diff_name = table.remove(vim.split(name, "/"))
                            else
                                table.insert(buffers, id)
                            end
                        end
                    end

                    -- Open buffer for diffed file
                    for _, id in ipairs(buffers) do
                        local name = vim.api.nvim_buf_get_name(id)

                        if vim.endswith(name, removed_diff_name) then
                            print("Name: " .. name)
                            vim.api.nvim_win_set_buf(0, id)
                        end
                    end
                end,
                desc = "Git Quit Diff"
            },
            { "<leader>gd", "<cmd>Gdiffsplit<cr>",   desc = "Git Diff" },
            { "<leader>gv", "<cmd>Gvdiffsplit!<cr>", desc = "Git Vertical Diff" },
            { "<leader>gb", "<cmd>Git blame<cr>",    desc = "Git Blame" },
            { "<leader>gh", "<cmd>diffget //2<cr>",  desc = "Git Diff Get Left" },
            { "<leader>gl", "<cmd>diffget //3<cr>",  desc = "Git Diff Get Right" },
        },
    },
}

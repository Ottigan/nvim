return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-jest",
    },
    keys = {
        {
            "<leader>tn",
            function()
                require("neotest").run.run()
            end,
            desc = "[T]est [N]earest",
        },
        {
            "<leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "[T]est [F]ile",
        },
        {
            "<leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "[T]est [S]ummary",
        },
        {
            "<leader>to",
            function()
                require("neotest").output.open({ enter = true })
            end,
            desc = "[T]est [O]utput",
        },
        {
            "<leader>tp",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "[T]est [P]anel",
        },
        {
            "<leader>tl",
            function()
                require("neotest").run.run_last()
            end,
            desc = "[T]est [L]ast",
        },
        {
            "<leader>tw",
            function()
                require("neotest").run.run({ jestCommand = "npx jest --watch" })
            end,
            desc = "[T]est [W]atch",
        },
        {
            "<leader>td",
            function()
                require("neotest").run.run({ strategy = "dap" })
            end,
            desc = "[T]est [D]ebug nearest",
        },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-jest")({
                    jestCommand = "yarn jest",
                    jestConfigFile = function(file)
                        local root = vim.fn.getcwd()
                        local dir = vim.fn.fnamemodify(file, ":h")

                        while #dir >= #root do
                            for _, name in ipairs({
                                "jest.config.ts",
                                "jest.config.js",
                                "jest.config.cjs",
                                "jest.config.mjs",
                            }) do
                                local candidate = dir .. "/" .. name
                                if vim.fn.filereadable(candidate) == 1 then
                                    return candidate
                                end
                            end
                            dir = vim.fn.fnamemodify(dir, ":h")
                        end

                        return root .. "/jest.config.ts"
                    end,
                    cwd = function()
                        return vim.fn.getcwd()
                    end,
                }),
            },
            -- Show test status in the sign column
            status = { virtual_text = true },
            -- Nicer output
            output = { open_on_run = true },
            -- Disable test discovery, as it can be slow in large projects --
            discovery = { enabled = false },
        })
    end,
}

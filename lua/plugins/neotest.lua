return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-jest",
        "nvim-neotest/neotest-go",
    },
    config = function()
        local function jest_cmd()
            if vim.fn.filereadable("pnpm-lock.yaml") == 1 then
                return "pnpm jest"
            elseif vim.fn.filereadable("yarn.lock") == 1 then
                return "yarn jest"
            else
                return "npx jest"
            end
        end

        require("neotest").setup({
            adapters = {
                require("neotest-go"),
                require("neotest-jest")({
                    jestCommand = jest_cmd,
                    jest_test_discovery = true, -- Discover it.each
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
            status = { enabled = true, virtual_text = true, signs = true },
            output = { enabled = true, open_on_run = true, },
            discovery = { concurrent = 0, enabled = false },
        })
    end,
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
                require("neotest").run.run({ jestCommand = jest_cmd() .. " --watch" })
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
}

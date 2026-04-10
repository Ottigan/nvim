return {
    {
        "linrongbin16/gitlinker.nvim",
        cmd = { "GitLink" },
        keys = {
            { "<leader>cu", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy remote URL" },
        },
        opts = {},
    },

    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
        dependencies = {
            "tpope/vim-rhubarb",
        },
        keys = {
            { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame File" },
            { "<leader>gh", "<cmd>diffget //2<cr>", desc = "Git Diff Get Left" },
            { "<leader>gl", "<cmd>diffget //3<cr>", desc = "Git Diff Get Right" },
        },
    },

    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff View" },
            { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Git File History" },
            { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Git Close Diff" },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        opts = {
            preview_config = {
                border = "rounded",
                style = "minimal",
                row = -1,
                col = 1,
            },
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, { desc = "Jump to next git [c]hange" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Jump to previous git [c]hange" })

                -- Actions
                -- visual mode
                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "git [s]tage hunk" })
                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "git [r]eset hunk" })
                -- normal mode
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk_inline, { desc = "git [p]review hunk" })
                map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
            end,
        },
        config = function(_, opts)
            local gitsigns = require("gitsigns")

            gitsigns.setup(opts)

            local deleted_preview = require("gitsigns.deleted_preview")
            local place_inline_preview_lines = deleted_preview.place_inline_preview_lines

            -- Override the default `place_inline_preview_lines` to disable the left column, which is not needed for deleted lines and can cause issues with certain color schemes.
            deleted_preview.place_inline_preview_lines = function(bufnr, ns, hunk, staged, preview_opts)
                preview_opts = vim.tbl_extend("force", preview_opts or {}, { leftcol = false })
                return place_inline_preview_lines(bufnr, ns, hunk, staged, preview_opts)
            end
        end,
    },
}

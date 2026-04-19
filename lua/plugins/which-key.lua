return { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        delay = 1000,
        icons = { mappings = vim.g.have_nerd_font },

        -- Document existing key chains
        spec = {
            { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
            { "<leader>g", group = "[G]it", mode = { "n", "v" } },
            { "<leader>q", group = "[Q]uit/[S]ession" },
            { "<leader>b", group = "[B]uffer" },
            { "<leader>d", group = "[D]ebug" },
            { "<leader>t", group = "[T]est" },
            { "<leader>x", group = "Diagnostic" },
            { "<leader>n", group = "[N]otifications" },
            { "<leader>c", group = "[C]opy" },
        },
    },
}

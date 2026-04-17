return {
    -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    ---@class tokyonight.Config
    ---@field on_colors fun(colors: ColorScheme)
    ---@field on_highlights fun(highlights: tokyonight.Highlights, colors: ColorScheme)
    opts = {
        cache = true,
        on_highlights = function(highlights, colors)
            highlights.NormalFloat = { bg = "none" }
            highlights.FloatBorder = { bg = "none", fg = colors.blue }
            highlights.FloatTitle = { bg = "none", fg = colors.blue, bold = true }

            highlights.BlinkCmpMenuBorder = { bg = "none", fg = colors.blue }
            highlights.BlinkCmpScrollBarThumb = { bg = colors.blue }
            highlights.BlinkCmpScrollBarGutter = { bg = "none" }
        end,
        transparent = true,
        styles = {
            comments = { italic = false }, -- Disable italics in comments
            sidebars = "transparent",
            floats = "transparent",
        },
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)

        -- Load the colorscheme here.
        -- Like many other themes, this one has different styles, and you could load
        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        vim.cmd.colorscheme("tokyonight-night")
    end,
}

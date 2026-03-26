-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
        { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    },
    opts = {
        close_if_last_window = false,
        popup_border_style = "", -- or "" to use 'winborder' on Neovim v0.11+
        window = {
            position = "float",
        },
        event_handlers = {
            {
                event = "neo_tree_window_after_open",
                handler = function()
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if
                            vim.api.nvim_buf_is_valid(buf)
                            and vim.api.nvim_buf_get_name(buf) == ""
                            and vim.bo[buf].buftype == ""
                        then
                            pcall(vim.api.nvim_buf_delete, buf, { force = false })
                        end
                    end
                end,
            },
        },
    },
}

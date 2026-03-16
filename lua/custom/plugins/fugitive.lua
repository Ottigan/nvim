return {
    "tpope/vim-fugitive",
    config = function()
        -- Optional: Add keymaps, e.g., <leader>gs for :Gstatus
        vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
    end,
}

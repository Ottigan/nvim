-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("TabLeave", {
     callback = function()
         if vim.bo.filetype == "DiffviewFiles" or vim.bo.filetype == "DiffviewDiff" then
             require("diffview").close()
         end
     end,
})

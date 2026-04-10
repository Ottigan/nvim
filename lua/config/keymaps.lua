-- Clear highlights on search and close floating windows when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", function()
    vim.cmd("nohlsearch")
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end)

-- Save
vim.keymap.set("n", "<D-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("i", "<D-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Copy
vim.keymap.set("n", "<leader>cr", function()
    vim.fn.setreg("+", vim.fn.fnamemodify(vim.fn.expand("%:p"), ":."))
end, { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>ca", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy absolute path" })

vim.keymap.set("n", "<leader>cf", function()
    vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy filename" })

vim.keymap.set("n", "<leader>cd", function()
    vim.fn.setreg("+", vim.fn.expand("%:p:h"))
end, { desc = "Copy directory path" })

vim.keymap.set("n", "<leader>cl", function()
    local file = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
    local line = vim.fn.line(".")
    vim.fn.setreg("+", file .. ":" .. line)
end, { desc = "Copy path:line" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "[B]uffer [D]elete (force)" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<leader>bx", "<cmd>%bdelete|edit#|bdelete#<CR>", { desc = "[B]uffer delete all e[X]cept current" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- Better indenting - stay in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Clear highlights on search and close floating windows when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", function()
    vim.cmd("nohlsearch")
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end)

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<}>", "<}>zz", { desc = "Next paragraph (centered)" })
vim.keymap.set("n", "<{>", "<{>zz", { desc = "Previous paragraph (centered)" })

-- Buffer management
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "[W]rite buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "[B]uffer [D]elete (force)" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<CR>", { desc = "[B]uffer [D]elete [O]thers" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resizing
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Quit/session
vim.keymap.set("n", "<leader>qq", "<cmd>quit<cr>", { desc = "[Q]uit window" })
vim.keymap.set("n", "<leader>qa", "<cmd>qall<cr>", { desc = "Quit [A]ll" })
vim.keymap.set("n", "<leader>qA", "<cmd>qall!<cr>", { desc = "Quit [A]ll (force)" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting - stay in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

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

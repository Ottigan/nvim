-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw (use Neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.winborder = "rounded"

-- Keep folds open by default (treesitter sets foldmethod=expr per filetype)
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.o.confirm = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

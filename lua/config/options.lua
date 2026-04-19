-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight the current line
vim.opt.wrap = false -- Don't wrap lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.breakindent = true -- Wrapped lines will be indented

-- Search settings
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase letters are used
vim.opt.hlsearch = false -- Highlight search results
vim.opt.incsearch = true -- Show search matches as you type

-- Visual settings
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.winborder = "rounded" -- Rounded float borders
vim.g.have_nerd_font = true -- Assume Nerd Font is available for icons
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- How long to show match
vim.opt.cmdheight = 1 -- Command line height
vim.opt.completeopt = "menuone,noselect" -- Completion options
vim.showmode = false -- Don't show -- INSERT -- etc.
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup transparency
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.conceallevel = 0 -- Don't hide markup
vim.opt.concealcursor = "" -- Don't hide markup in cursor line
vim.opt.lazyredraw = true -- Don't redraw while executing macros
vim.opt.synmaxcol = 300 -- Don't syntax highlight long lines

-- File handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup files while writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Faster key sequence timeout
vim.opt.ttimeoutlen = 0 -- Don't wait for key codes
vim.opt.autoread = true -- Auto-reload files changed outside of Vim
vim.opt.autowrite = false -- Don't auto-save files

-- Behaviour settings
vim.opt.hidden = true -- Allow hidden buffers
vim.opt.errorbells = false -- Disable error bells
vim.opt.backspace = "indent,eol,start" -- Backspace behavior
vim.opt.autochdir = false -- Don't change working directory automatically
vim.opt.path:append("**") -- Search in subdirectories
vim.opt.selection = "exclusive" -- Selection behavior
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.modifiable = true -- Allow modifying buffers
vim.opt.encoding = "utf-8" -- Set encoding
vim.opt.confirm = true -- Confirm before exiting with unsaved changes
vim.opt.inccommand = "split" -- Show live preview of substitutions

-- Folding settings
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldlevelstart = 99 -- Start with all folds open

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- Disable netrw (use Neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- Line numbers
opt.nu = true
opt.relativenumber = true

-- Linebreak
opt.wrap = false

-- Curser line
opt.cursorline = true
opt.colorcolumn = "120"

-- Indenting
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Split for replaces
opt.inccommand = "split"

-- Search settings
opt.smartcase = true
opt.ignorecase = true

-- Scrollin
opt.scrolloff = 10

-- split windows
opt.splitright = true
opt.splitbelow = true

-- Undo
opt.undofile = true

-- Swap
opt.swapfile = false

-- Colors
opt.termguicolors = true

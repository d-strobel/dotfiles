local keymap = vim.keymap

-- Remove highlight search
keymap.set('n', '<ESC>', '<cmd>nohlsearch<cr>')

-- Disable space in normal mode
keymap.set("n", "<Space>", "<Nop>")

-- Move multilines in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Centralize while going page up and down
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Void registry pasting
keymap.set("x", "<leader>p", [["_dP]])

-- Copy to system clipboard
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

-- Paste form system clipboard
keymap.set({ "n", "v" }, "<leader>p", [["+p]])
keymap.set("n", "<leader>P", [["+P]])

-- Delete to void registry
keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Sarch and replace in current file
keymap.set("n", "<leader>sr", ":%s/")
keymap.set("v", "<leader>sr", "y:%s/<C-r>\"", { noremap = true, silent = false })

-- Sarch and replace in quickfix
keymap.set("n", "<leader>qr", ":cdo :%s/")
keymap.set("n", "<leader>qR", ":cfdo :%s/")

-- Open Quickfix list
keymap.set("n", "<leader>qo", "<cmd>copen<CR>")
keymap.set("n", "<leader>qc", "<cmd>cclose<CR>")

-- Remap cnext and cprev for quickfix lists
keymap.set('n', '<leader>qj', '<cmd>cnext<CR>zz')
keymap.set('n', '<leader>qk', '<cmd>cprev<CR>zz')

-- Diagnostics
keymap.set("n", "<leader>d", vim.diagnostic.open_float)

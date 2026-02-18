-----------------------------
--: Leader
-----------------------------
vim.g.mapleader = " "

-----------------------------
--: Options
-----------------------------
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.winborder = 'single'
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-----------------------------
--: Keymaps
-----------------------------
vim.keymap.set('n', '<ESC>', '<cmd>nohlsearch<cr>')             -- Remove highlight search
vim.keymap.set("n", "<Space>", "<Nop>")                         -- Disable space in normal mode
vim.keymap.set("v", "<", "<gv")                                 -- keep visual selection when (de)indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true }) -- Move multilines in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")                         -- Centralize while going page up and down
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("x", "<leader>p", [["_dP]])                      -- Void registry pasting
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])              -- Copy to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])              -- Paste from system clipboard
vim.keymap.set("n", "<leader>P", [["+P]])
vim.keymap.set("v", "p", '"_dP')                                -- Paste over currently selected text without yanking it
vim.keymap.set("v", "P", '"_dP')
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])              -- Delete to void registry
vim.keymap.set("n", "<leader>sr", ":%s/")                       -- Search and replace in current file
vim.keymap.set("v", "<leader>sr", "y:%s/<C-r>\"", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>qr", ":cdo :%s/")                  -- Quickfix search and replace
vim.keymap.set("n", "<leader>qR", ":cfdo :%s/")                 -- Quickfix search and replace
vim.keymap.set("n", "<leader>qq", "<cmd>copen<CR>")             -- Quickfix list open
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>")            -- Quickfix list open
vim.keymap.set('n', '<M-n>', '<cmd>cnext<CR>zz')                -- Quickfix next
vim.keymap.set('n', '<M-p>', '<cmd>cprev<CR>zz')                -- Quickfix next

-----------------------------
--: Statusline
-----------------------------
vim.wo.statusline = '%= %<%t %h%w%m%r %= [%l,%c] %{&fileencoding} %{&filetype}'

-----------------------------
--: Colorscheme
-----------------------------
vim.pack.add({
  { src = "https://github.com/p00f/alabaster.nvim", name = "alabaster" },
})
vim.cmd.colorscheme "alabaster"

-----------------------------
--: Diagnostics
-----------------------------
vim.diagnostic.config({
  virtual_text = true,
})

-----------------------------
--: Filetypes
-----------------------------
vim.filetype.add({
  extension = {
    -- Terraform
    tf = "terraform",
    tfvars = "hcl",
    tfbackend = "config",
    tfstate = "json",
    -- Systemd
    service = "systemd",
    timer = "systemd",
  }
})

-----------------------------
--: General autocmds
-----------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-----------------------------
--: Dependency packages
-----------------------------
vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

-----------------------------
--: Treesitter
-----------------------------
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require('nvim-treesitter.config').setup {
  ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "yaml", "xml", "typst", "typescript", "toml", "tmux", "terraform", "ssh_config", "rust", "regex", "python", "promql", "nix", "nginx", "markdown-inline", "markdown", "make", "lua", "latex", "java", "just", "json", "kdl", "ini", "hyprlang", "html", "helm", "hcl", "gosum", "gomod", "go", "gitignore", "gitcommit", "fish", "editorconfig", "dockerfile", "csv", "css", "c", "bash", "astro" },
  install_dir = vim.fn.stdpath('data') .. '/site',
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-----------------------------
--: Explorer
-----------------------------
vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
})
require("oil").setup({
  use_default_keymaps = false,
  keymaps = {
    ["<CR>"] = "actions.select",
    ["<C-l>"] = "actions.select",
    ["\""] = { "actions.select", opts = { horizontal = true } },
    ["%"] = { "actions.select", opts = { vertical = true } },
    ["<Esc>"] = { "actions.close", mode = "n" },
    ["<leader>e"] = { "actions.parent", mode = "n" },
  },
  columns = { "icon" },
  view_options = { show_hidden = true },
})
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")

-----------------------------
--: Picker
-----------------------------
vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    path_display = { "truncate " },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-l>"] = actions.select_default,
      },
      n = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-l>"] = actions.select_default,
        ["%"] = actions.select_vertical,
        ["\""] = actions.select_horizontal,
      },
    },
  },
})
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fp", builtin.git_files, { desc = "[F]ind [P]roject (Git) files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep (live)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[F]ind [M]arks" })
vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "[F]ind [J]umps" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })

-----------------------------
--: Marks
-----------------------------
local prefixes = "m'"
local letters = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #prefixes do
  local prefix = prefixes:sub(i, i)
  local action_prefix = ""
  if prefix == "'" then
    action_prefix = "`"
  else
    action_prefix = prefix
  end
  for j = 1, #letters do
    local lower_letter = letters:sub(j, j)
    local upper_letter = string.upper(lower_letter)
    vim.keymap.set({ "n", "v" }, prefix .. lower_letter, action_prefix .. upper_letter)
  end
end

-----------------------------
--: Git
-----------------------------
vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
})
vim.keymap.set("n", "<leader>gs", "<CMD>Git<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", "<CMD>Git commit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gp", "<CMD>Git push<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gd", "<CMD>Git diff<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gD", "<CMD>Telescope git_status<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gl", "<CMD>Git log<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gL", "<CMD>Telescope git_commits<CR>", { noremap = true, silent = true })

-----------------------------
--: Cloak
-----------------------------
vim.pack.add({
  { src = "https://github.com/laytan/cloak.nvim" },
})
require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  highlight_group = "Comment",
  patterns = {
    {
      file_pattern = {
        ".env*",
      },
      cloak_pattern = "=.+"
    },
  }
})

-----------------------------
--: Undotree
-----------------------------
vim.pack.add({
  { src = "https://github.com/mbbill/undotree" },
})
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-----------------------------
--: Completion
-----------------------------
vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp" },
})
require("blink.cmp").setup({
  keymap = {
    preset = 'none',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-l>'] = { 'select_and_accept' },
    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<Tab>'] = { 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
  },
  appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'mono' },
  cmdline = { enabled = false },
  sources = { default = { 'lsp', 'path', 'buffer' } },
  signature = { enabled = true },
  completion = {
    menu = { border = 'none' },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
})

-----------------------------
--: LSP
-----------------------------
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim.git" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
  { src = "https://github.com/neovim/nvim-lspconfig.git" },
})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Keymaps
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)

    -- Auto-format on save.
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      -- Keymap for toggle
      vim.keymap.set("n", '<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle LSP inlay hints" })
    end

    -- Organize Imports
    if client:supports_method("textDocument/codeAction") then
      -- Auto organize imports for all go code
      if vim.bo.filetype == "go" then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.code_action {
              context = {
                only = { "source.organizeImports" },
                diagnostics = vim.diagnostic.get(),
                triggerKind = 2,
              },
              apply = true,
            }
          end
        })
      end
    end
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
      signatureHelp = { enabled = true },
      telemetry = { enabled = false },
      workspace = {
        library = vim.tbl_extend(
          "keep",
          { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          vim.api.nvim_get_runtime_file("", true)
        ),
      },
    },
  },
})

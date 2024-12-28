local api = vim.api

-- Highlight when yanking (copying) text
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- LspAttach
api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Format on save
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
      api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end

    -- Inlay hints
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      -- Enable by default
      vim.lsp.inlay_hint.enable(true)

      -- Keymap for toggle
      vim.keymap.set("n", '<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end)
    end
  end
})

-- Diagnostic config
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'single',
  },
})

-- Filetypes
vim.filetype.add({
  extension = {
    -- Terraform
    tf = "terraform",
    tfvars = "terraform",
    tfbackend = "config",
    tfstate = "json",
    -- Systemd
    service = "systemd",
    timer = "systemd",
  }
})

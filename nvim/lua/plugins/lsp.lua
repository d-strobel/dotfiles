return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
          border = "rounded"
        },

        -- list of servers for mason to install
        ensure_installed = {
          "ansiblels",
          "gopls",
          "lua_ls",
          "rust_analyzer",
          "terraformls",
          "yamlls",
          "powershell_es",
          "jsonls",
          "dockerls",
          "html",
          "pylsp",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "single"
        }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = "single"
        }
      )

      -- Lua
      lspconfig["lua_ls"].setup {
        capabilities = capabilities
      }
      -- Go
      lspconfig["gopls"].setup {
        capabilities = capabilities
      }
      -- Rust
      lspconfig["rust_analyzer"].setup {
        capabilities = capabilities
      }
      -- Ansible
      lspconfig["ansiblels"].setup {
        capabilities = capabilities,
        filetypes = { "yaml", "ansible" }
      }
      -- Terraform
      lspconfig["terraformls"].setup {
        capabilities = capabilities,
        filetypes = { "tf", "terraform", "terraform-vars" },
      }
      -- Powershell lsp config
      lspconfig["powershell_es"].setup({
        capabilities = capabilities,
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
      })

      -- JSON lsp config
      lspconfig["jsonls"].setup({
        capabilities = capabilities,
      })

      -- Dockerfile lsp config
      lspconfig["dockerls"].setup({
        capabilities = capabilities,
      })

      -- HTML lsp config
      lspconfig["html"].setup({
        capabilities = capabilities,
      })
      --
      -- HTMX lsp config
      lspconfig["htmx"].setup({
        capabilities = capabilities,
      })

      -- Tailwind CSS lsp config
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
      })

      -- Python lsp config
      lspconfig["pylsp"].setup({
        capabilities = capabilities,
      })

      -- OnAttach functions
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Format on save
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
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
    end,
  },
}

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
          border = "single"
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
    end,
  },
}

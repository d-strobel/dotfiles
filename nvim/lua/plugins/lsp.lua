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
          "bashls",
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
        filetypes = { "ansible" },
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
      -- Python lsp config
      lspconfig["pylsp"].setup({
        capabilities = capabilities,
      })
      -- Yaml
      lspconfig["yamlls"].setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              -- Kubernetes
              kubernetes = "*.manifest.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
              "*flow*.{yml,yaml}",
              -- Github
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-2.0"] = ".github/dependabot.{yml,yaml}",
              -- Gitlab
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
              "*gitlab-ci*.{yml,yaml}",
              -- Azure
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
              "azure-pipelines*.{yml,yaml}",
              -- Ansible
              ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] =
              "tasks/*.{yml,yaml}",
              ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] =
              "*{play,site}*.{yml,yaml}",
              -- OpenAPI
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
              "*api*.{yml,yaml}",
              -- Docker
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "*docker-compose*.{yml,yaml}",
              -- Go
              ["https://golangci-lint.run/jsonschema/golangci.jsonschema.json"] = ".golangci.{yml,yaml}",
              -- Prometheus
              ["https://json.schemastore.org/prometheus.json"] = "prometheus.{yml.yaml}",
              ["https://json.schemastore.org/prometheus.rules.json"] = "*.rules.{yml,yaml}",
              ["https://json.schemastore.org/prometheus.rules.test.json"] = "*.tests.{yml,yaml}",
            },
          }
        }
      })
    end,
  },
}

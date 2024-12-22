return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
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
        columns = {
          "icon",
        },
        view_options = {
          show_hidden = true,
        },
      })

      vim.keymap.set("n", "<space>e", "<CMD>Oil<CR>")
    end,
  },
}

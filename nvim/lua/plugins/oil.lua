return {
  {
    "stevearc/oil.nvim",
    lazy = true,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<space>e", "<cmd>Oil<cr>" }
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
    end,
  },
}

return {
  {
    "yetone/avante.nvim",
    lazy = true,
    version = false,
    opts = {
      provider = "copilot",
    },
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk" }
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
    },
  }
}

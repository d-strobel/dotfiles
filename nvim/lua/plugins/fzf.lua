return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    opts = {
      oldfiles = {
        cwd_only = true,
      },
      winopts = {
        on_create = function()
          vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
          vim.keymap.set("t", "<C-l>", "<CR>", { silent = true, buffer = true })
        end,
      },
      files = {
        git_icons = false,
        file_icons = false,
      },
    },
    keys = {
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>",             desc = "Find (Live) Grep" },
      { "<leader>ff", "<cmd>FzfLua files<cr>",                 desc = "Find Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>",               desc = "Find Buffers" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Find Diagnostics" },
      { "<leader>/",  "<cmd>FzfLua lgrep_curbuf<cr>",          desc = "Search in current buffer" },
    },
  },
}

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local keymap = vim.keymap

    telescope.setup({
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

    -- set keymaps
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    keymap.set("n", "<leader>fp", builtin.git_files, { desc = "[F]ind [P]roject files" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep (live)" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    keymap.set({ "n", "v" }, "<leader>fw", builtin.grep_string, { desc = "[F]ind current [Word]" })
  end,
}

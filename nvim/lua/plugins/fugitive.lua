return {
  "tpope/vim-fugitive",
  config = function()
    local keymap = vim.keymap

    -- Git status
    keymap.set("n", "<leader>gs", "<CMD>Git<CR>", { noremap = true, silent = true })

    -- Git commit with message input
    keymap.set("n", "<leader>gc", function()
      local msg = vim.fn.input("Commit message > ")
      -- Concat message string
      if msg ~= "" then
        msg = "Git commit -q -m '" .. msg
        vim.cmd(msg .. "'")
      else
        vim.cmd("Git commit")
      end
    end, { noremap = true, silent = true })

    -- Other usefull keymaps
    keymap.set("n", "<leader>gp", "<CMD>Git push<CR>", { noremap = true, silent = true })
    keymap.set("n", "<leader>gd", "<CMD>Git diff<CR>", { noremap = true, silent = true })
    keymap.set("n", "<leader>gD", "<CMD>Telescope git_status<CR>", { noremap = true, silent = true })
    keymap.set("n", "<leader>gl", "<CMD>Git log<CR>", { noremap = true, silent = true })
    keymap.set("n", "<leader>gL", "<CMD>Telescope git_commits<CR>", { noremap = true, silent = true })
  end
}

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        enable = {},
        variant = "main",
        styles = {
          bold = false,
          italic = false,
          transparency = true,
        },

        dark_variant = "main",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
      })

      -- Set colorscheme
      vim.cmd.colorscheme "rose-pine"

      -- Background color for floating windows
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "PMenu", { bg = "#1e1e2e" })
    end
  }
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "c",
          "query",
          "json",
          "yaml",
          "html",
          "css",
          "markdown",
          "markdown_inline",
          "bash",
          "lua",
          "vim",
          "vimdoc",
          "dockerfile",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "rust",
          "hcl",
          "terraform",
          "fish",
          "diff",
          "git_config",
          "promql",
          "toml",
          "slint",
        },

        modules = {},
        ignore_install = {},
        sync_install = false,
        auto_install = false,

        highlight = {
          enable = true,

          -- Disable treesitter for big files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          additional_vim_regex_highlighting = false,
        },
      }
    end
  }
}

return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup()
    end,
  },
  {
    "folke/tokyonight.nvim", -- Color Scheme
    lazy = false,
  },
  {
    "EdenEast/nightfox.nvim", -- Color Scheme
    lazy = false,
  },
  {
    "mg979/vim-visual-multi",
    event = "BufEnter"
  },
  {
    "dart-lang/dart-vim-plugin",
  },
  {
    'akinsho/flutter-tools.nvim',
    after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
  }
}

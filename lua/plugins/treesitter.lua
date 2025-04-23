return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
    local configs = require("nvim-treesitter.configs")
    config = function():
    configs.setup({
    ensure_installed = { "lua", "elixir", "javascript", "html", "terraform", "php" },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },  
})
  end,
  }

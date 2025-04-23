vim.cmd("set expandtab") -- Faz com que o tab adicione espaços ao invés de um caractere de tabulação
vim.cmd("set tabstop=2") -- Tab irá contar como dois espaços
vim.cmd("set softtabstop=2") -- Usa dois espaços ao pressionar Tab no modo de inserção
vim.cmd("set shiftwidth=2") -- Usará dois espaços para identação
vim.o.autoident = true
vim.o.smartident = true
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--local plugins = require("plugins")
local opts = {}
require("lazy").setup("plugins")

local configs = require("nvim-treesitter.configs")
configs.setup({
          ensure_installed = { "lua", "elixir", "javascript", "html", "terraform", "php" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
})

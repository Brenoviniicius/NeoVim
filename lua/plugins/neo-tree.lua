return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true,          -- mostra os arquivos ocultos
          hide_dotfiles = false,  -- não esconde arquivos que começam com "."
          hide_gitignored = false -- mostra arquivos ignorados pelo Git também
        }
      }
    })
      vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
  end
}



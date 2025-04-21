-- ⬇️ Adiciona o lazy.nvim no runtime
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site/pack/lazy/start/lazy.nvim")

-- ⬇️ Instala e configura plugins com lazy.nvim
require("lazy").setup({

	-- Tema visual
	{ "catppuccin/nvim",               name = "catppuccin",                       priority = 1000 },

	-- Árvore de arquivos
	{ "nvim-tree/nvim-tree.lua" },
	{ "nvim-tree/nvim-web-devicons" }, -- ícones para nvim-tree

	{ "akinsho/bufferline.nvim",       version = "*",                             dependencies = "nvim-tree/nvim-web-devicons" },

	-- Barra de status
	{ "nvim-lualine/lualine.nvim" },

	-- Telescope: busca de arquivos e texto
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- LSP (suporte a linguagens)
	{ "neovim/nvim-lspconfig" },

	-- Autocompletar
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		}
	},


	{ "voldikss/vim-floaterm" },

})

-- ⬇️ Tema
vim.cmd [[colorscheme catppuccin]]

-- ⬇️ nvim-tree configuração
require("nvim-tree").setup(
	{
		view = {
			width = 30,
			side = "left",
			preserve_window_proportions = true,
		},
		renderer = {
			group_empty = true,
		},
		actions = {
			open_file = {
				quit_on_open = false, -- mantém a árvore aberta ao abrir um arquivo
				resize_window = true,
			}
		},
		update_focused_file = {
			enable = true,
			update_cwd = true,
		}
	})


-- ⬇️ lualine configuração
require("lualine").setup {
	options = {
		theme = "catppuccin"
	}
}

require("bufferline").setup {}
vim.opt.termguicolors = true

-- ⬇️ telescope configuração
require("telescope").setup {}

-- ⬇️ LSP básico com Lua (troque por sua linguagem, se quiser)
local lspconfig = require("lspconfig")
-- Lua
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				-- Usa a versão do Lua que o Neovim usa (geralmente LuaJIT)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Reconhece as variáveis globais do Neovim
				globals = { 'vim' },
			},
			workspace = {
				-- Faz com que o LSP reconheça os arquivos do Neovim
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				-- Desativa envio de dados anônimos
				enable = false,
			},
		},
	},
}

-- PHP
lspconfig.phpactor.setup {
	on_attach = function()
		vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
	end,
	init_options = {
		["language_server_phpstan.enabled"] = true,
		["language_server_psalm.enabled"] = true,
	}
}

-- JavaScript / Node.js
lspconfig.tsserver.setup { cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
	settings = {
		documentFormatting = false,
	},
	on_attach = function()
		vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
	end, }

-- SQL
lspconfig.sqlls.setup { cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql" },
	root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
	settings = {}
}

-- Terraform
lspconfig.terraformls.setup {}

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.lua", "*.php", "*.ts", "*.js", "*.sql", "*.tf" },
	callback = function()
		vim.lsp.buf.format()
	end,
})

-- ⬇️ Autocompletar com cmp + luasnip
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}),
})

-- ⬇️ Atalhos produtivos
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-f>", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-t>", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- Navegar entre buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })



vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
})

-- Abrir automaticamente o nvim-tree ao iniciar o Neovim
local function open_nvim_tree_on_startup(data)
	-- Evita abrir a árvore se for um terminal ou diretório especial
	local real_file = vim.fn.filereadable(data.file) == 1
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
	if not real_file and not no_name then
		return
	end

	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = open_nvim_tree_on_startup,
})

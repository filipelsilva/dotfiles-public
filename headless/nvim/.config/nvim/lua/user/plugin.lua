-- Automatically install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Protected call so that first use does not result in error
local ok, lazy = pcall(require, "lazy")

if not ok then
	return
end

-- Plugins
lazy.setup({
	-- Indentation detector
	"tpope/vim-sleuth",

	-- Surround stuff
	{
		"tpope/vim-surround",
		dependencies = {
			"tpope/vim-repeat"
		}
	},

	-- Comment stuff
	"tpope/vim-commentary",

	-- Git wrapper
	"tpope/vim-fugitive",

	-- Vim session wrapper
	"tpope/vim-obsession",

	-- Undo tree
	"mbbill/undotree",

	-- Navigate between vim/neovim and tmux
	"christoomey/vim-tmux-navigator",

	-- Fzf
	{
		"junegunn/fzf.vim",
		dependencies = {
			{
				"junegunn/fzf",
				build = ":call fzf#install()"
			}
		}
	},

	-- REPL integration
	"jpalardy/vim-slime",

	-- Colorscheme
	"gruvbox-community/gruvbox",

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make"
			}
		}
	},

	-- LSP
	{
		"dundalek/lazy-lsp.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"whonore/Coqtail"
		}
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippets
			"L3MON4D3/LuaSnip",
			-- Completion sources
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-git"
		}
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/playground",
		}
	},
})

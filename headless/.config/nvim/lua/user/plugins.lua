local fn = vim.fn

-- Automatically install packer.nvim
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
	vim.cmd([[packadd packer.nvim]])
end

-- Protected call so that first use does not result in error
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Packer settings
packer.init({
	display = {
		working_sym = "[WORKING]",
		error_sym = "[ERROR]",
		done_sym = "[DONE]",
		removed_sym = "[REMOVED]",
		moved_sym = "[MOVED]",
		header_sym = "",
	}
})

-- Plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- Indentation detector
	use("tpope/vim-sleuth")

	-- Surround stuff
	use("tpope/vim-surround")

	-- Comment stuff
	use("numToStr/Comment.nvim")

	-- Colorscheme
	use("gruvbox-community/gruvbox")

	-- Fzf
	use("junegunn/fzf.vim")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim"
		}
	})

	-- Lsp
	use({
		"neovim/nvim-lspconfig",
		requires = {
			-- Auto installer
			"williamboman/nvim-lsp-installer"
		}
	})

	-- Completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			-- Snippets
			"L3MON4D3/LuaSnip",
			-- Completion sources
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path"
		}
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/playground"
		}
	})

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

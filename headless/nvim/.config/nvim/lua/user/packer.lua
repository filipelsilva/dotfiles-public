-- Automatically install packer.nvim
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
		vim.cmd("packadd packer.nvim")
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- Protected call so that first use does not result in error
local ok, packer = pcall(require, "packer")

if not ok then
	return
end

-- Plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- Indentation detector
	use("tpope/vim-sleuth")

	-- Surround stuff
	use({
		"tpope/vim-surround",
		requires = {
			"tpope/vim-repeat"
		}
	})

	-- Comment stuff
	use('tpope/vim-commentary')

	-- Vim wrapper
	use('tpope/vim-fugitive')

	-- Undo tree
	use("mbbill/undotree")

	-- Fzf
	use("junegunn/fzf.vim")

	-- Colorscheme
	use("gruvbox-community/gruvbox")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			"nvim-lua/plenary.nvim"
		}
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			-- Auto installer
			{
				"williamboman/mason.nvim",
				requires = {
					"williamboman/mason-lspconfig.nvim",
				}
			},
			-- Signatures
			"ray-x/lsp_signature.nvim"
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
			"nvim-treesitter/playground",
		}
	})

	if packer_bootstrap then
		packer.sync()
	end
end)

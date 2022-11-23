-- Automatically install packer.nvim {{{
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path
	})
	vim.cmd("packadd packer.nvim")
end
-- }}}

-- Protected call so that first use does not result in error
local packer = REQUIRE({
	"packer"
})

-- Settings {{{
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
-- }}}

-- Plugins
return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- Indentation detector
	use("tpope/vim-sleuth")

	-- Surround stuff
	use("kylechui/nvim-surround")

	-- Comment stuff
	use("numToStr/Comment.nvim")

	-- Extra keybinds
	use("tpope/vim-unimpaired")

	-- Git wrapper
	use("tpope/vim-fugitive")

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

	if PACKER_BOOTSTRAP then
		packer.sync()
	end
end)

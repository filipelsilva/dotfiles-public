local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"dockerfile",
		"go",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"json",
		"lua",
		"make",
		"markdown",
		"nix",
		"python",
		"rust",
		"toml",
		"typescript",
		"vim"
	},
	sync_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	playground = {
		enable = true,
	},
})

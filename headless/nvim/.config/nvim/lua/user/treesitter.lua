local treesitter = REQUIRE({
	"nvim-treesitter.configs"
})

treesitter.setup({
	-- Enabled languages {{{
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"dockerfile",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"lua",
		"make",
		"markdown",
		"nix",
		"python",
		"query",
		"rust",
		"toml",
		"typescript",
		"vim"
	},
	-- }}}
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

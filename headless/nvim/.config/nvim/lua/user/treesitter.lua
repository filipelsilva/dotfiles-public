local treesitter, context = REQUIRE({
	"nvim-treesitter.configs",
	"treesitter-context"
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

context.setup({
	enable = true,
	max_lines = 0,
	trim_scope = "outer",
	min_window_height = 0,
})

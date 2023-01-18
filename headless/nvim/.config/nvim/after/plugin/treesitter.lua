local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if not ok then
	return
end

treesitter.setup({
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
		"ruby",
		"rust",
		"toml",
		"typescript",
		"vim"
	},
	sync_install = true,
	highlight = {
		enable = true,
		disable = {
			"markdown"
		},
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = false,
	},
	playground = {
		enable = true,
	},
})

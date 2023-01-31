local ok_telescope, telescope = pcall(require, "telescope")
local ok_actions, actions = pcall(require, "telescope.actions")

if not ok_telescope or not ok_actions then
	return
end

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "flex",
		layout_config = {
			prompt_position = "top",
			width = 0.80,
			height = 0.90,
		},
		path_display = {
			"truncate",
		},
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-s>"] = actions.select_horizontal,
				["<C-x>"] = false,
				["<C-a>"] = actions.select_all,
			},
			n = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-s>"] = actions.select_horizontal,
				["<C-x>"] = false,
				["<C-a>"] = actions.select_all,
			},
		},
		vimgrep_arguments = {
			"rg",
			"--hidden",
			"--vimgrep",
			"--no-heading",
			"--smart-case",
		},
	},
})

telescope.load_extension("fzf")

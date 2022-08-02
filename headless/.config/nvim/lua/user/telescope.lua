local telescope, builtin, actions = REQUIRE("telescope", "telescope.builtin", "telescope.actions")

-- Keymaps {{{
local telescope_keybind_options = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>a", "<Cmd>Telescope<CR>", telescope_keybind_options)

vim.keymap.set("n", "<Leader>f", function()
	if vim.fn.len(vim.fn.system("git rev-parse")) == 0 then
		builtin.git_files({ hidden = true })
	else
		builtin.find_files({ hidden = true })
	end
end, telescope_keybind_options)

vim.keymap.set("n", "<Leader>F", function()
	builtin.find_files({
		cwd = require("telescope.utils").buffer_dir(),
		hidden = true
	})
end, telescope_keybind_options)

vim.keymap.set("n", "<Leader><Leader>f", function()
	builtin.find_files({
		cwd = "$HOME",
		hidden = true
	})
end, telescope_keybind_options)

vim.keymap.set("n", "<Leader><Leader>e", function()
	builtin.find_files({
		cwd = "$HOME/.config/nvim",
		hidden = true,
		follow = true
	})
end, telescope_keybind_options)

vim.keymap.set("n", "<Leader>r", function()
	builtin.live_grep()
end, telescope_keybind_options)

vim.keymap.set("n", "<Leader>j", function()
	builtin.buffers()
end, telescope_keybind_options)
-- }}}

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "flex",
		layout_config = {
			prompt_position = "top",
			width = 0.90,
			height = 0.60,
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

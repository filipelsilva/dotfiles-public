_G.TELESCOPE_FUZZY_FILE = function()
	if vim.fn.len(vim.fn.system("git rev-parse")) == 0 then
		require("telescope.builtin").git_files({ hidden = true })
	else
		require("telescope.builtin").find_files({ hidden = true })
	end
end

local telescope_keybind_options = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>a", [[<Cmd>Telescope<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>f", [[<Cmd>lua TELESCOPE_FUZZY_FILE()<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>F", [[<Cmd>lua require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir(), hidden = true })<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader><Leader>f", [[<Cmd>lua require("telescope.builtin").find_files({ cwd = "$HOME", hidden = true })<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader><Leader>e", [[<Cmd>lua require("telescope.builtin").find_files({ cwd = "$HOME/.config/nvim/lua/user", hidden = true, follow = true })<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>r", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>j", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], telescope_keybind_options)

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")

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
				["<c-s>"] = actions.select_horizontal,
				["<c-x>"] = false,
				["<c-a>"] = actions.select_all,
			},
			n = {
				["<c-s>"] = actions.select_horizontal,
				["<c-x>"] = false,
				["<c-a>"] = actions.select_all,
			},
		},
	},
})

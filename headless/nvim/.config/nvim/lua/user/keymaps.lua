local telescope_builtin, telescope_utils = REQUIRE({
	"telescope.builtin",
	"telescope.utils"
})

local opts = { noremap = true, silent = true }

-- Telescope keybinds
vim.keymap.set("n", "<Leader>a", "<Cmd>Telescope<CR>", opts)

vim.keymap.set("n", "<Leader>f", function()
	telescope_builtin.find_files({ hidden = true })
end, opts)

vim.keymap.set("n", "<Leader>F", function()
	telescope_builtin.find_files({
		cwd = telescope_utils.buffer_dir(),
		hidden = true
	})
end, opts)

vim.keymap.set("n", "<Leader><Leader>f", function()
	telescope_builtin.find_files({
		cwd = "$HOME",
		hidden = true
	})
end, opts)

vim.keymap.set("n", "<Leader>g", function()
	telescope_builtin.git_files({ hidden = true })
end, opts)

vim.keymap.set("n", "<Leader>r", function()
	telescope_builtin.live_grep({
		glob_pattern = "!*.git"
	})
end, opts)

vim.keymap.set("n", "<Leader>j", function()
	telescope_builtin.buffers()
end, opts)

-- Edit nvim configuration files
vim.keymap.set("n", "<Leader><Leader>e", function()
	telescope_builtin.find_files({
		cwd = "$HOME/.config/nvim",
		hidden = true,
		follow = true
	})
end, opts)

-- Edit nvim configuration folder
vim.keymap.set("n", "<Leader><Leader>E", "<Cmd>edit $HOME/.config/nvim/lua/user<CR>", opts)

local ok, telescope_builtin = pcall(require, "telescope.builtin")

if not ok then
	return
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>t", "<Cmd>Telescope<CR>", opts)

vim.keymap.set("n", "<Leader>f", function()
	local is_home = os.getenv("HOME") == os.getenv("PWD")
	telescope_builtin.find_files({
		hidden = not is_home
	})
end, opts)

vim.keymap.set("n", "<Leader>F", function()
	telescope_builtin.find_files({
		cwd = "$HOME",
		hidden = true
	})
end, opts)

vim.keymap.set("n", "<Leader>g", function()
	telescope_builtin.git_files({
		hidden = true
	})
end, opts)

vim.keymap.set("n", "<Leader>r", function()
	telescope_builtin.live_grep({
		glob_pattern = {
			"!*.git",
			"!*.hg" ,
			"!*.svn",
			"!*CVS"
		}
	})
end, opts)

vim.keymap.set("n", "<Leader>j", function()
	telescope_builtin.buffers()
end, opts)

-- Edit nvim configuration files
vim.keymap.set("n", "<Leader>e", function()
	telescope_builtin.find_files({
		cwd = "$HOME/.config/nvim",
		hidden = true,
		follow = true
	})
end, opts)

-- Edit nvim configuration folder
vim.keymap.set("n", "<Leader>E", "<Cmd>edit $HOME/.config/nvim/lua/user<CR>", opts)

-- Edit vim configuration file
vim.keymap.set("n", "<Leader><Leader>e", "<Cmd>edit $HOME/.vimrc<CR>", opts)

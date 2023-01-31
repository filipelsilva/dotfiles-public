local ok, telescope_builtin = pcall(require, "telescope.builtin")

if not ok then
	return
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>t", "<Cmd>Telescope<CR>", opts)

vim.keymap.set("n", "<Leader>f", function()
	if vim.fn.len(vim.fn.system("git rev-parse")) == 0 then
		telescope_builtin.git_files({
			hidden = true,
			show_untracked = true
		})
	else
		local is_home = os.getenv("HOME") == os.getenv("PWD")
		telescope_builtin.find_files({
			hidden = not is_home
		})
	end
end, opts)

vim.keymap.set("n", "<Leader>r", function()
	telescope_builtin.live_grep({
		glob_pattern = { "!*.git", "!*.hg" , "!*.svn", "!*CVS" }
	})
end, opts)

vim.keymap.set("n", "<Leader>j", function()
	telescope_builtin.buffers()
end, opts)

-- Edit nvim configuration files
vim.keymap.set("n", "<Leader><Leader>v", function()
	telescope_builtin.find_files({
		cwd = "$HOME/.config/nvim",
		hidden = true,
		follow = true
	})
end, opts)

-- Edit vim configuration file
vim.keymap.set("n", "<Leader>v", "<Cmd>edit $HOME/.vimrc<CR>", opts)

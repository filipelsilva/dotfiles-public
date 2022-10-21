-- Fix neovim triggering tmux events
-- This is not a good fix, but for now it's the best one
vim.opt.eventignore:append({
	"FocusGained",
	"FocusLost"
})

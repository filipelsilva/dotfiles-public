-- Fix neovim triggering tmux events
-- This is not a good fix, but for now it's the best one
vim.opt.eventignore:append({
	"FocusGained",
	"FocusLost"
})

-- Disable virtual text for diagnostics (use popup instead)
vim.diagnostic.config({
	virtual_text = false,
})

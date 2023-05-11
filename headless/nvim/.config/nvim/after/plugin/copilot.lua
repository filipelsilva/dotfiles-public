local ok_copilot, copilot = pcall(require, "copilot")
local ok_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")

if not ok_copilot or not ok_copilot_cmp then
	return
end

copilot.setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

copilot_cmp.setup()

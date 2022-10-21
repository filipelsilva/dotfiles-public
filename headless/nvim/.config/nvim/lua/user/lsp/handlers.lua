M = {}

local cmp_nvim_lsp = REQUIRE({
	"cmp_nvim_lsp"
})

-- Update capabilities of LSP to support snippets
M.capabilities = cmp_nvim_lsp.default_capabilities()

-- LSP on_attach function to define settings and keybinds only if a LSP exists
M.on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts)
	vim.keymap.set("n", "<Leader><Leader>a", [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], opts)
	vim.keymap.set("n", "<Leader>k", [[<Cmd>lua vim.lsp.buf.hover()<CR>]], opts)
	vim.keymap.set("n", "<Leader>s", [[<Cmd>lua vim.lsp.buf.rename()<CR>]], opts)
	vim.keymap.set("n", "[e", [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]], opts)
	vim.keymap.set("n", "]e", [[<Cmd>lua vim.diagnostic.goto_next()<CR>]], opts)
end

return M

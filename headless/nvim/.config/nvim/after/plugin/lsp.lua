-- Update capabilities of LSP to support snippets
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok_cmp_nvim_lsp then
	return
end

local custom_capabilities = cmp_nvim_lsp.default_capabilities()

-- LSP on_attach function to define settings and keybinds only if a LSP exists
local custom_on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<Leader>a", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<Leader>k", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<Leader>s", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next() end, opts)
end

-- Lazy lsp: uses nix-shell to spawn LSPs
local ok, lazylsp = pcall(require, "lazy-lsp")

if not ok then
	return
end

lazylsp.setup({
	excluded_servers = {
		"sqls",
	},
	preferred_servers = {
		c = { "clangd" },
		cpp = { "clangd" },
	},
	default_config = {
		flags = {},
		on_attach = custom_on_attach,
		capabilities = custom_capabilities,
	},
	configs = {
		lua_ls = {
			settings = { Lua = { diagnostics = { globals = { "vim" } } } }
		},
	},
})

-- Coq configuration
vim.g.coqtail_nomap = 1
vim.g.coqtail_noimap = 1

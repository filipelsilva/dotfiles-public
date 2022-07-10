local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

lsp_installer.setup({
	ui = {
		icons = {
			server_installed = "[INSTALLED]",
			server_pending = "[PENDING]",
			server_uninstalled = "[UNINSTALLED]",
		},
	},
})

local custom_on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], bufopts)
	vim.keymap.set("n", "<Leader><Leader>a", [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], bufopts)
	vim.keymap.set("n", "<Leader>k", [[<Cmd>lua vim.lsp.buf.hover()<CR>]], bufopts)
	vim.keymap.set("n", "<Leader>s", [[<Cmd>lua vim.lsp.buf.rename()<CR>]], bufopts)
	vim.keymap.set("n", "[e", [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]], bufopts)
	vim.keymap.set("n", "]e", [[<Cmd>lua vim.diagnostic.goto_next()<CR>]], bufopts)
end

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

local new_capabilities = vim.lsp.protocol.make_client_capabilities()
new_capabilities.textDocument.completion.completionItem.snippetSupport = true
new_capabilities = cmp_nvim_lsp.update_capabilities(new_capabilities)

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local servers = require("nvim-lsp-installer.servers").get_installed_servers()

for _, server in pairs(servers) do
	lspconfig[server.name].setup({
		on_attach = custom_on_attach,
		capabilities = new_capabilities,
		settings = (server.name == "sumneko_lua" and { Lua = { diagnostics = { globals = { "vim" } } } } or nil),
	})
end

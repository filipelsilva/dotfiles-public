local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

-- Settings
lsp_installer.setup({
	ui = {
		icons = {
			server_installed = "[INSTALLED]",
			server_pending = "[PENDING]",
			server_uninstalled = "[UNINSTALLED]",
		},
	},
})

-- Custom server settings {{{
local sumneko_lua_settings = { Lua = { diagnostics = { globals = { "vim" } } } }
-- }}}

-- Configure every server
local servers = require("nvim-lsp-installer.servers").get_installed_servers()

for _, server in pairs(servers) do
	lspconfig[server.name].setup({
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
		-- Stop the "vim" keyword from being marked as an error on configs
		settings = (server.name == "sumneko_lua" and sumneko_lua_settings or nil),
	})
end

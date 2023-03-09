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

	if client.server_capabilities.goto_definition then
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
	end
	if client.server_capabilities.code_action then
		vim.keymap.set("n", "<Leader>a", function()
			vim.lsp.buf.code_action()
		end, opts)
	end
	if client.server_capabilities.hover then
		vim.keymap.set("n", "<Leader>k", function()
			vim.lsp.buf.hover()
		end, opts)
	end
	if client.server_capabilities.rename then
		vim.keymap.set("n", "<Leader>r", function()
			vim.lsp.buf.rename()
		end, opts)
	end
	vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next() end, opts)
end

-- Load mason
local ok_mason, mason = pcall(require, "mason")
local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")

if not ok_mason or not ok_mason_lspconfig or not ok_lspconfig then
	return
end

mason.setup()

-- Setup mason with lspconfig
mason_lspconfig.setup({
	ensure_installed = {
		"asm_lsp",
		"bashls",
		"clangd",
		"dockerls",
		"eslint",
		"gopls",
		"html",
		"jdtls",
		"lua_ls",
		"pyright",
		"rnix",
		"ruby_ls",
		"rust_analyzer",
		"terraformls",
		"texlab",
		"tsserver",
		"vimls"
	}
})

mason_lspconfig.setup_handlers({
	function(server_name) -- Default handler
		lspconfig[server_name].setup({
			on_attach = custom_on_attach,
			capabilities = custom_capabilities,
		})
	end,
	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			on_attach = custom_on_attach,
			capabilities = custom_capabilities,
			settings = { Lua = { diagnostics = { globals = { "vim" } } } }
		})
	end,
})

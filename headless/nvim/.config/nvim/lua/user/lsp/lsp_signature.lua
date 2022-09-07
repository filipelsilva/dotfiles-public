local signature = REQUIRE({
	"lsp_signature"
})

signature.setup({
	bind = true,
	handler_opts = { border = "none" },
	hint_enable = false,
	padding = " ",
})

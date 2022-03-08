source $HOME/dotfiles/files/vimrc

" Plugins {{{
function! PackInit() abort
	packadd minpac
	call minpac#init()
	call minpac#add("k-takata/minpac", {"type": "opt"})

	" Indentation detector
	call minpac#add("tpope/vim-sleuth")

	" Surround stuff
	call minpac#add("tpope/vim-surround")

	" Comment stuff
	call minpac#add("numToStr/Comment.nvim")

	" Colorscheme
	call minpac#add("gruvbox-community/gruvbox")

	" Fzf
	call minpac#add("junegunn/fzf.vim")

	" Telescope requirement
	call minpac#add("nvim-lua/plenary.nvim")

	" Telescope
	call minpac#add("nvim-telescope/telescope.nvim")
	call minpac#add("nvim-telescope/telescope-fzf-native.nvim", { "do": "make" })

	" Lsp and autoinstall
	call minpac#add("neovim/nvim-lspconfig")
	call minpac#add("williamboman/nvim-lsp-installer")

	" Snippets
	call minpac#add("L3MON4D3/LuaSnip")

	" Completion sources
	call minpac#add("hrsh7th/cmp-nvim-lsp")
	call minpac#add("saadparwaiz1/cmp_luasnip")
	call minpac#add("hrsh7th/cmp-buffer")
	call minpac#add("hrsh7th/cmp-path")
	call minpac#add("hrsh7th/cmp-cmdline")

	" Completion
	call minpac#add("hrsh7th/nvim-cmp")

	" Treesitter
	call minpac#add("nvim-treesitter/nvim-treesitter", { "do": "TSUpdate" })
	call minpac#add("nvim-treesitter/playground")

endfunction
" }}}

" Colorscheme
set termguicolors
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
let g:gruvbox_invert_selection = 0
let g:gruvbox_invert_signs = 1
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox

" Telescope keybinds
nnoremap <silent> <expr> <Leader>f (len(system("git rev-parse")) ? ":Telescope find_files hidden=true" : ":Telescope git_files hidden=true")."\<CR>"
nnoremap <silent> <Leader><Leader>f <Cmd>lua require("telescope.builtin").find_files({ cwd = "$HOME", hidden = true })<CR>
nnoremap <silent> <Leader>F <Cmd>lua require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir(), hidden = true })<CR>
nnoremap <silent> <Leader>r <Cmd>Telescope live_grep<CR>
nnoremap <silent> <Leader>j <Cmd>Telescope buffers<CR>

lua << EOF

-- Telescope {{{
local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
	defaults = {
		layout_strategy = "flex",
		layout_config = {
			prompt_position = "top",
			width = 0.90,
			height = 0.60,
		},
		path_display = {
			"smart",
		},
		mappings = {
			i = {
				["<c-s>"] = actions.select_horizontal,
				["<c-x>"] = false,
				["<c-a>"] = actions.select_all,
			},
			n = {
				["<c-s>"] = actions.select_horizontal,
				["<c-x>"] = false,
				["<c-a>"] = actions.select_all,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	},
})
telescope.load_extension("fzf")
-- }}}

-- Comment.nvim {{{
local comment = require("Comment")
comment.setup({
	padding = true,
	sticky = true,
	ignore = nil,
	toggler = {
		line = "gcc",
		block = "gbb",
	},
	opleader = {
		line = "gc",
		block = "gb",
	},
	extra = {
		above = "gcO",
		below = "gco",
		eol = "gcA",
	},
	mappings = {
		basic = true,
		extra = true,
		extended = true,
	},
	pre_hook = nil,
	post_hook = nil,
})
-- }}}

-- LSP {{{
local custom_on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<Leader>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "[e", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]e", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

local new_capabilities = vim.lsp.protocol.make_client_capabilities()
new_capabilities = require("cmp_nvim_lsp").update_capabilities(new_capabilities)

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings({
	ui = {
		icons = {
			server_installed = "->",
			server_pending = "??",
			server_uninstalled = "!!",
		},
	},
})
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = custom_on_attach,
		capabilities = new_capabilities,
	}
	server:setup(opts)
end)
-- }}}

-- LuaSnip {{{
local ls = require("luasnip")
-- Requirements {{{
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local types = require("luasnip.util.types")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
-- }}}

ls.config.setup({
	history = true,
	enable_autosnippets = true,
	updateevents = "TextChanged,TextChangedI",
})

-- Templates {{{
c_template = [[
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	$0
}
]]

cpp_template = [[
#include <bits/stdc++.h>

using namespace std;

int main(int argc, char *argv[]) {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr); cout.tie(nullptr);

	$0
}
]]
-- }}}

ls.snippets = {
	all = {
	},
	c = {
		ls.parser.parse_snippet("init", c_template),
	},
	cpp = {
		ls.parser.parse_snippet("init", cpp_template),
	},
}
-- }}}

-- Nvim-cmp {{{
local cmp = require("cmp")

-- Helper functions {{{
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Next completion or move in snippet
local complete_or_snippet_next = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif ls.expand_or_jumpable() then
		ls.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

-- Previous completion or move in snippet
local complete_or_snippet_prev = function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif ls.jumpable(-1) then
		ls.jump(-1)
	else
		fallback()
	end
end

local luasnip_option_forward = function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end
-- }}}

cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<C-l>"] = cmp.mapping(luasnip_option_forward, { "i" }),
		["<C-n>"] = cmp.mapping(complete_or_snippet_next, { "i", "s" }),
		["<C-p>"] = cmp.mapping(complete_or_snippet_prev, { "i", "s" }),
		["<Tab>"] = cmp.mapping(complete_or_snippet_next, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(complete_or_snippet_prev, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})
-- }}}

-- Treesitter {{{
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
	ensure_installed = "maintained",
	sync_install = false,
	highlight = {
		enable = false,
		additional_vim_regex_highlighting = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = false,
	},
	playground = {
		enable = true,
	},
})
-- }}}

EOF

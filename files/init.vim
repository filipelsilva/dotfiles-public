source $HOME/dotfiles/files/defaults.vim

" Plugins {{{
function! PackInit() abort
	packadd minpac
	call minpac#init()
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	" Identation detector
	call minpac#add('timakro/vim-yadi')

	" Comment stuff
	call minpac#add('numToStr/Comment.nvim')

	" Surround stuff
	call minpac#add('tpope/vim-surround')

	" Colorscheme
	call minpac#add('gruvbox-community/gruvbox')

	" Fzf
	call minpac#add('junegunn/fzf.vim')

	" Lsp and autoinstall
	call minpac#add('neovim/nvim-lspconfig')
	call minpac#add('williamboman/nvim-lsp-installer')

	" Snippets
	call minpac#add('L3MON4D3/LuaSnip')

	" Completion sources
	call minpac#add('hrsh7th/cmp-nvim-lsp')
	call minpac#add('saadparwaiz1/cmp_luasnip')
	call minpac#add('hrsh7th/cmp-buffer')
	call minpac#add('hrsh7th/cmp-path')
	call minpac#add('hrsh7th/cmp-cmdline')

	" Completion
	call minpac#add('hrsh7th/nvim-cmp')

	" Treesitter
	call minpac#add('nvim-treesitter/nvim-treesitter')
	call minpac#add('nvim-treesitter/playground')

endfunction
" }}}

" Colorscheme
set termguicolors
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
let g:gruvbox_invert_selection = 0
let g:gruvbox_invert_signs = 1
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
highlight! link Character80 ColorColumn

" Fzf (overrides defaults.vim keybinds on f key, due to fzf.vim being used here)
nnoremap <silent> <expr> <Leader>f (len(system("git rev-parse")) ? ":Files" : ":GFiles") . "\<CR>"
nnoremap <silent> <Leader>r <Cmd>Rg<CR>
nnoremap <silent> <Leader>j <Cmd>Buffers<CR>

" Comment.nvim {{{
lua << EOF
local comment = require('Comment')
comment.setup({
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
        line = 'gcc',
        block = 'gbb',
    },
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
    },
    mappings = {
        basic = true,
        extra = true,
        extended = true,
    },
    pre_hook = nil,
    post_hook = nil,
})
EOF
" }}}

" LSP {{{
lua << EOF
local custom_on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', '<Leader>k', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local new_capabilities = vim.lsp.protocol.make_client_capabilities()
new_capabilities = require('cmp_nvim_lsp').update_capabilities(new_capabilities)

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.settings({
    ui = {
        icons = {
            server_installed = '->',
            server_pending = '??',
            server_uninstalled = '!!',
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
EOF
" }}}

" Completion {{{
lua << EOF
local luasnip = require('luasnip')
local cmp = require('cmp')

-- Helper functions {{{
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

-- Next completion or move in snippet
local complete_or_snippet_next = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
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
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end
-- }}}

-- Snippets {{{
local snip = luasnip.snippet
local node = luasnip.snippet_node
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node
local choice = luasnip.choice_node
local dynamic = luasnip.dynamic_node

luasnip.snippets = {}
-- }}}

-- Completion engine {{{
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-y>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		['<C-n>'] = cmp.mapping(complete_or_snippet_next, { 'i', 's' }),
		['<C-p>'] = cmp.mapping(complete_or_snippet_prev, { 'i', 's' }),
		['<Tab>'] = cmp.mapping(complete_or_snippet_next, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(complete_or_snippet_prev, { 'i', 's' }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	}),
})
-- }}}
EOF
" }}}

" Treesitter {{{
lua << EOF
local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
	ensure_installed = {},
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
EOF
" }}}

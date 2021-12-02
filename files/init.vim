source $HOME/dotfiles/files/defaults.vim

" Plugins {{{
function! PackInit() abort
	packadd minpac
	call minpac#init()
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	" Identation detector
	call minpac#add('timakro/vim-yadi')

	" Comment stuff
	call minpac#add('tpope/vim-commentary')

	" Surround stuff
	call minpac#add('tpope/vim-surround')

	" Colorscheme
	call minpac#add('lifepillar/vim-gruvbox8')

	" Fzf
	call minpac#add('junegunn/fzf.vim')

	" Lsp and autoinstall
	call minpac#add('neovim/nvim-lspconfig')
	call minpac#add('williamboman/nvim-lsp-installer')

	" Snippets
	call minpac#add('L3MON4D3/LuaSnip')

	" Completion sources
	call minpac#add('saadparwaiz1/cmp_luasnip')
	call minpac#add('hrsh7th/cmp-buffer')
	call minpac#add('hrsh7th/cmp-path')
	call minpac#add('hrsh7th/cmp-nvim-lsp')

	" Completion
	call minpac#add('hrsh7th/nvim-cmp')

	" Treesitter
	call minpac#add('nvim-treesitter/nvim-treesitter')
	call minpac#add('nvim-treesitter/playground')

endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
" }}}

" Colorscheme
set background=dark
set termguicolors
colorscheme gruvbox8_hard
highlight! link CursorLineNr LineNr
highlight! link EndOfBuffer LineNr
highlight! link Character80 ColorColumn

" DetectIndent
augroup DetectIndent
	autocmd!
	autocmd BufRead * DetectIndent
augroup END

" Fzf (overrides defaults.vim keybinds on f key, due to fzf.vim being used here)
nnoremap <silent> <expr> <Leader>f (len(system("git rev-parse")) ? ":Files" : ":GFiles") . "\<CR>"
nnoremap <silent> <Leader>r <Cmd>Rg<CR>
nnoremap <silent> <Leader>j <Cmd>Buffers<CR>

" LSP {{{
set omnifunc=v:lua.vim.lsp.omnifunc

lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
new_capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
			select = true,
		}),
		['<C-n>'] = cmp.mapping(complete_or_snippet_next, { 'i', 's' }),
		['<C-p>'] = cmp.mapping(complete_or_snippet_prev, { 'i', 's' }),
		['<Tab>'] = cmp.mapping(complete_or_snippet_next, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(complete_or_snippet_prev, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	},
})
-- }}}
EOF
" }}}

" Treesitter {{{
lua << EOF
local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
	ensure_installed = 'maintained',
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

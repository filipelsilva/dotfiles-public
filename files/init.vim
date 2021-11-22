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
highlight! TrailingWhitespace ctermbg=red guibg=red

" DetectIndent
augroup DetectIndent
	autocmd!
	autocmd BufRead * DetectIndent
augroup END

" Fzf {{{
set runtimepath+=$HOME/.fzf

function! s:build_quickfix_list(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

let g:fzf_action = {
	\ 'ctrl-q': function('s:build_quickfix_list'),
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-s': 'split',
	\ 'ctrl-v': 'vsplit' }
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
let g:fzf_layout = { 'down': '30%' }
let g:fzf_buffers_jump = 1

nnoremap <silent> <expr> <Leader>f (len(system("git rev-parse")) ? ":Files" : ":GFiles") . "\<CR>"
nnoremap <silent> <Leader><Leader>f <Cmd>Files $HOME<CR>
nnoremap <silent> <Leader>r <Cmd>Rg<CR>
nnoremap <silent> <Leader>j <Cmd>Buffers<CR>
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"
tnoremap <expr> <C-j> (&filetype == "fzf") ? "<C-n>" : "<C-j>"
tnoremap <expr> <C-k> (&filetype == "fzf") ? "<C-p>" : "<C-k>"
" }}}

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

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
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
EOF
" }}}

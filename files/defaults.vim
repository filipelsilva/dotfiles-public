" Settings {{{
syntax enable
filetype plugin indent on

set omnifunc=syntaxcomplete#Complete
set nomodeline nocompatible hidden confirm
set encoding=utf-8 fileformats=unix,dos,mac
set updatetime=100 ttimeoutlen=0
set mouse=a

if !has("nvim")
	" Set mouse mode
	set ttymouse=xterm2
	" Enable matchit (extends the use of %)
	runtime! macros/matchit.vim
	" Enable :Man <search>
	runtime! ftplugin/man.vim
endif

colorscheme elflord

" Highlight 80th character (cleaner alternative to colorcolumn)
highlight! link Character80 ColorColumn
call matchadd("Character80", '\%80v.')

" Embed language syntax support
let g:vimsyn_embed="lmpPrt"

" K under cursor uses :Man
set keywordprg=:Man

" Folds (marker = 3*'{')
set foldmethod=marker

" Search settings
set ignorecase smartcase incsearch hlsearch

" Completion menu settings
set wildmenu wildmode=longest:full,full completeopt=menuone,noinsert,noselect

" Splits to the right and bottom
set splitright splitbelow

" Backspace settings
set backspace=indent,eol,start

" Indentation settings
set autoindent copyindent shiftround smarttab breakindent
set noexpandtab textwidth=0 tabstop=4 softtabstop=4 shiftwidth=4

" Visual settings
set ruler showcmd linebreak laststatus=1
set shortmess=filmnrwxaoOtT fillchars+=vert:│ guicursor=

" Spell settings
set spelllang=en,pt

" Diff options
set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

" Make gf (follow file) work with file_name=/path/to/file
set isfname-==

" Don't use octal for <C-x> and <C-a>
set nrformats=bin,hex

" If rg exists, use it
if executable("rg")
	set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
	set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Undo, swap/backup files settings
set undofile undolevels=10000
if has("nvim")
	if empty(glob($HOME . "/.nvim-tmp"))
		for subfolder in ["undo", "swp", "backup"]
			call mkdir($HOME . "/.nvim-tmp/" . subfolder, "p")
		endfor
	endif
	set undodir=$HOME/.nvim-tmp/undo//
	set directory=$HOME/.nvim-tmp/swp//
	set backupdir=$HOME/.nvim-tmp/backup//
else
	if empty(glob($HOME . "/.vim-tmp"))
		for subfolder in ["undo", "swp", "backup"]
			call mkdir($HOME . "/.vim-tmp/" . subfolder, "p")
		endfor
	endif
	set undodir=$HOME/.vim-tmp/undo//
	set directory=$HOME/.vim-tmp/swp//
	set backupdir=$HOME/.vim-tmp/backup//
endif
" }}}

" Functions {{{

" HighlightToggle {{{
function! StartHL() abort
	let s:pos = match(getline('.'), @/, col('.') - 1) + 1
	if s:pos != col('.')
		call StopHL()
	endif
endfunction

function! StopHL() abort
	if !v:hlsearch || mode() isnot 'n'
		return
	else
		silent call feedkeys("\<Plug>(StopHL)", 'm')
	endif
endfunction
" }}}

" ShowWhitespace {{{
function! ShowWhitespace() abort
	if exists("s:whitespace")
		call matchdelete(s:whitespace)
		unlet s:whitespace
	else
		highlight! Whitespace ctermbg=red guibg=red
		let s:whitespace = matchadd("Whitespace", '\v\s+$')
	endif
endfunction
" }}}

" TrimWhitespace {{{
function! TrimWhitespace() abort
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction
" }}}

" CreateUndoBreakPoint {{{
function! CreateUndoBreakPoint(char) abort
	" This funcion creates a insert mode map with undo break points
	execute "inoremap " . a:char . " " . a:char . "<C-g>u"
endfunction
" }}}

" CreateTextObject {{{
function! CreateTextObject(char) abort
	" This funcion creates a new text object from the cursor position after the
	" last occurence of the char, until (a)the next occurence of the char itself
	" or the cursor position before the next occurence (i).
	execute "onoremap <silent> i" . a:char . " :<C-u>normal! T" . a:char . "vt" . a:char . "<CR>"
	execute "xnoremap <silent> i" . a:char . " :<C-u>normal! T" . a:char . "vt" . a:char . "<CR>"
	execute "onoremap <silent> a" . a:char . " :<C-u>normal! F" . a:char . "vf" . a:char . "<CR>"
	execute "xnoremap <silent> a" . a:char . " :<C-u>normal! F" . a:char . "vf" . a:char . "<CR>"
endfunction
" }}}

" }}}

" Commands {{{

" Cd to where the current file is edited (changes only for the current window)
command! CDC lcd %:p:h

" Diff between the current buffer and the file it was loaded from
command! DiffOrig vertical new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis

" TrimWhitespace
command! TrimWhitespace call TrimWhitespace()

" CreateUndoBreakPoint
command! -nargs=1 CreateUndoBreakPoint call CreateUndoBreakPoint(<f-args>)

" CreateTextObject
command! -nargs=1 CreateTextObject call CreateTextObject(<f-args>)

" }}}

" Autocommands {{{
augroup Vimrc
	autocmd!

	" Load vimrc after saving it
	autocmd BufWritePost $MYVIMRC source % | echomsg "Reloaded " . $MYVIMRC

	" Go to last edited position on open file
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# 'commit' | execute "normal! g'\"" | endif

	" If vim window is resized, resize the splits within
	autocmd VimResized * wincmd =

augroup END

augroup NumberToggle
	autocmd!

	" If buffer is in focus, enable relative numbers
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &number && mode() != "i" | set relativenumber | endif

	" If buffer gets out of focus, disable relative numbers
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &number | set norelativenumber | endif

augroup END

augroup HighlightToggle
	autocmd!

	" After some cursor movement, remove highlighting from text
	autocmd CursorMoved * call StartHL()
	autocmd InsertEnter * call StopHL()

augroup END
" }}}

" Keymaps {{{

" <Leader> key bind
let mapleader = "\<Space>"

" Easier completion menus
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Easier navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
tnoremap <C-w> <C-\><C-n><C-w>

" Toggle numbers
nnoremap <silent> <Leader>n :set invnumber invrelativenumber<CR>

" Toggle spell
nnoremap <silent> <Leader>o :setlocal invspell<Bar>call ShowWhitespace()<CR>

" Buffer jumping
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
inoremap <C-^> <Esc><C-^>

" Alternative tab jumping
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprev<CR>

" Quickfix list jumping
nnoremap ]q :cnext<CR>zz
nnoremap [q :cprev<CR>zz
nnoremap ]l :lnext<CR>zz
nnoremap [l :lprev<CR>zz

" Like o and O but stays on cursor
nnoremap <silent> ]<Space> :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> [<Space> :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

" Substitute word under cursor ('s': wherever | 'S': word only)
nnoremap <Leader>s :%s/<C-r><C-w>//g<Left><Left>
vnoremap <Leader>s "zy<Esc>:%s/<C-r>z//g<Left><Left>
nnoremap <Leader>S :%s/\<<C-r><C-w>\>//g<Left><Left>
vnoremap <Leader>S "zy<Esc>:%s/\<<C-r>z\>//g<Left><Left>

" Create quickfix list with searched word
if executable("rg")
	nnoremap <Leader>q :grep! "<cword>" .<CR> <Bar> :copen<CR>
	vnoremap <Leader>q "zy<Esc>:grep! "<C-r>z" .<CR> <Bar> :copen<CR>
else
	nnoremap <Leader>q :grep! -R -I --exclude-dir={.git,.svn} "<cword>" .<CR> <Bar> :copen<CR>
	vnoremap <Leader>q "zy<Esc>:grep! -R -I --exclude-dir={.git,.svn} "<C-r>z" .<CR> <Bar> :copen<CR>
endif

" Open files quickly
if executable("fzf")
	nnoremap <silent> <Leader>f <Cmd>FZF<CR>
	nnoremap <silent> <Leader><Leader>f <Cmd>FZF $HOME<CR>
	nnoremap <silent> <Leader>F :FZF <C-r>=substitute(expand("%:p:h"), " ", "\\\\ ", "g")<CR><CR>
else
	nnoremap <Leader>f :edit $PWD/
	nnoremap <Leader><Leader>f :edit $HOME/
	nnoremap <Leader>F :edit <C-r>=expand("%:p:h") . "/"<CR>
endif

" Make Y work like D and C
nnoremap Y y$

" Center cursor when searching or joining lines (zz: center, zv: open folds)
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo break points (add or remove more, according to needs)
for char in [".", ",", "!", "?"]
	call CreateUndoBreakPoint(char)
endfor

" Text objects (add or remove more, according to needs)
for char in [".", ",", ";", "/", "\\"]
	call CreateTextObject(char)
endfor

" Add <number>[jk] to jumplists
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'

" Move blocks of code
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Make . to work with visually selected lines
vnoremap . :normal.<CR>

" Disable highlighting
nnoremap <silent> <Leader>, :nohlsearch<CR>

" Run line as command, output here
noremap Q !!$SHELL<CR>

" Open $SHELL in splits
if has("nvim")
	noremap <silent> <Leader>t :vsplit term://$SHELL<CR>i
	noremap <silent> <Leader>T :split term://$SHELL<CR>i
else
	noremap <silent> <Leader>t :vertical terminal<CR>
	noremap <silent> <Leader>T :terminal<CR>
endif

" Quickly edit/reload the vimrc file
nmap <silent> <Leader>e :edit $MYVIMRC<CR>
nmap <silent> <Leader>E :source $MYVIMRC<CR>

" Shortcuts to use blackhole register
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d
nnoremap <Leader>D "_D
vnoremap <Leader>D "_D
nnoremap <Leader>c "_c
vnoremap <Leader>c "_c
nnoremap <Leader>C "_C
vnoremap <Leader>C "_C
nnoremap <Leader>x "_x
vnoremap <Leader>x "_x
nnoremap <Leader>X "_X
vnoremap <Leader>X "_X

" Copy to/Paste from the clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>Y "+y$
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

" Copy the whole working file to the clipboard
nnoremap <Leader><Leader>y :%yank+<CR>

" Disable hlsearch right after moving
noremap <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]

" Output the current syntax group
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}

" Fzf {{{
if executable("fzf")
	" Add fzf to runtimepath, adds :FZF command
	execute "set runtimepath+=" . fnamemodify(systemlist("readlink -f $(command -v fzf)")[0], ":h:h")

	" Create quickfix list out of selected files
	function! s:build_quickfix_list(lines)
		call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
		copen
		cc
	endfunction

	" Keymaps
	tnoremap <expr> <C-j> (&filetype == "fzf") ? "<C-n>" : "<C-j>"
	tnoremap <expr> <C-k> (&filetype == "fzf") ? "<C-p>" : "<C-k>"

	" Settings
	let g:fzf_action = {
		\ 'alt-q': function('s:build_quickfix_list'),
		\ 'ctrl-t': 'tab split',
		\ 'ctrl-s': 'split',
		\ 'ctrl-v': 'vsplit' }
	let g:fzf_buffers_jump = 1
endif
" }}}

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

endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

" Autoinstall package manager
if empty(glob(substitute(&packpath, ",.*", "", "") . "/pack/minpac/opt/minpac"))
	call system("git clone https://github.com/k-takata/minpac " . substitute(&packpath, ",.*", "", "") . "/pack/minpac/opt/minpac")
	autocmd VimEnter * silent! PackUpdate
endif
" }}}

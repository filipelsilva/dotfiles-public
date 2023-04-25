" Settings {{{
syntax enable
filetype plugin indent on

if &compatible
	set nocompatible
endif
set omnifunc=syntaxcomplete#Complete
set nomodeline hidden confirm noerrorbells visualbell
set encoding=utf-8 fileformats=unix,dos,mac
set updatetime=100 ttimeoutlen=0 mouse=a

if !has("nvim")

	" Enable matchit (extends the use of %)
	runtime! macros/matchit.vim

	" Enable :Man <search>
	runtime! ftplugin/man.vim

endif

" Embed language syntax support
let g:vimsyn_embed="lmpPrt"
let g:markdown_fenced_languages = ["bash", "zsh", "python", "lua", "go", "ruby", "perl"]

" Netrw settings
let g:netrw_banner = 1
let g:netrw_browse_split = 0
let g:netrw_keepdir = 0
let g:netrw_liststyle = 1
let g:netrw_winsize = 25

" K under cursor uses :Man
set keywordprg=:Man

" Folds (marker = 3*'{')
set foldmethod=marker

" Search settings
set ignorecase smartcase incsearch hlsearch

" Completion menu settings
set completeopt=menuone,noinsert,noselect
set wildmenu wildmode=longest:full,full

" Backspace settings
set backspace=indent,eol,start

" Text formatting settings
set autoindent copyindent shiftround smarttab breakindent nofixendofline
set noexpandtab tabstop=8 softtabstop=8 shiftwidth=8

" Visual settings
set ruler showcmd linebreak wrap number relativenumber
set laststatus=2 signcolumn=auto display=truncate colorcolumn=80
set listchars=tab:<->,trail:-,nbsp:+,eol:$ shortmess=OtTF

" Motions keep cursor on the same column
set nostartofline

" Spell languages
set spelllang=en,pt

" Diff options
set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

" Make gf (follow file) work with file_name=/path/to/file
set isfname-==

" Make gf (follow file) work with hidden suffixes
set suffixesadd=.py,.lua,.java

" Don't use octal for <C-x> and <C-a>
set nrformats=bin,hex

" Language may disable some keybinds, stop that
set nolangremap

" If rg exists, use it
if executable("rg")
	set grepprg=rg\ --hidden\ --vimgrep\ --no-heading\ --smart-case
	set grepformat=%f:%l:%c:%m,%f:%l:%m
else
	set grepprg=grep\ --recursive\ --line-number\ --ignore-case
endif

" Save vim variables between sessions
if has("nvim")
	set shada='50,<1000,s1000,\"100,:100,n$HOME/.nvim-tmp/shada
else
	set viminfo='50,<1000,s1000,\"100,:100,n$HOME/.vim-tmp/viminfo
endif

" Undo/swap/backup files
set undofile undolevels=10000 history=10000

let s:folder = $HOME . "/." . (has("nvim") ? "n" : "") . "vim-tmp"

let s:subfolders = [["undodir", "undo"]]
let s:subfolders += [["directory", "swp"]]
let s:subfolders += [["backupdir", "backup"]]

if empty(glob(s:folder))
	for subfolder in s:subfolders
		call mkdir(s:folder . "/" . subfolder[1], "p")
	endfor
endif

for subfolder in s:subfolders
	execute "set " . subfolder[0] . "=" . s:folder . "/" . subfolder[1] . "//"
endfor
" }}}

" Functions {{{

" CreateUndoBreakPoint {{{
function! CreateUndoBreakPoint(char) abort
	execute "inoremap " . a:char . " " . a:char . "<C-g>u"
endfunction
" }}}

" CreateTextObject {{{
function! CreateTextObject(char) abort
	for mode in ['xnoremap', 'onoremap']
		execute mode . " <silent> i" . a:char . " :<C-u>normal! T" . a:char . "vt" . a:char . "<CR>"
		execute mode . " <silent> a" . a:char . " :<C-u>normal! F" . a:char . "vf" . a:char . "<CR>"
	endfor
endfunction
" }}}

" OSC52Yank {{{
function! OSC52Yank() abort
	let buffer=system("base64 | tr -d '\n'", @0)
	let buffer='\033]52;c;' . buffer . '\033\'
	silent exe "!echo -ne " . shellescape(buffer) . " > " . (exists("g:tty") ? shellescape(g:tty) : "/dev/tty")
	redraw!
endfunction

command! OSC52Yank call OSC52Yank()
" }}}

" TrimWhitespace {{{
function! TrimWhitespace() abort
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction

command! TrimWhitespace call TrimWhitespace()
" }}}

" }}}

" Commands {{{

" Cd to where the current file is edited (changes only for the current window)
command! CD lcd %:p:h

" Diff between the current buffer and the file it was loaded from
command! DiffOrig vertical new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis

" }}}

" Autocommands {{{
augroup Vimrc
	autocmd!

	" Load vimrc after saving it
	autocmd BufWritePost $MYVIMRC source % | echomsg "Reloaded " . $MYVIMRC

	" Go to last edited position on open file
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# "commit" | execute "normal! g'\"" | endif

	" Change formatoptions everywhere
	autocmd FileType * setlocal formatoptions=tcqj

	" All gitconfig files with gitconfig filetype
	autocmd BufNewFile,BufRead *gitconfig* setfiletype gitconfig

augroup END

augroup PlainTextWidth
	autocmd!

	" On plain text files, set textwidth to something other than 0
	autocmd FileType text,markdown,rst,tex,latex,context,plaintex,gitcommit setlocal textwidth=80 spell

augroup END

augroup NumberToggle
	autocmd!

	" If buffer is in focus, enable relative numbers
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &number && mode() != "i" | set relativenumber | endif

	" If buffer gets out of focus, disable relative numbers
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &number | set norelativenumber | endif

augroup END
" }}}

" Keymaps {{{

" <Leader> key bind
let mapleader = "\<Space>"

" Easier navigation in splits
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Open netrw
nnoremap <Leader>e <Cmd>Explore<CR>

" Toggle list mode (see tabs, trailing spaces, et cetera)
nnoremap <Leader>l <Cmd>set invlist<CR>

" Toggle spell
nnoremap <Leader><Leader>l <Cmd>set invspell<CR>

" Disable highlighting
nnoremap <Leader>, <Cmd>nohlsearch<CR>

" Quick buffer switching in Insert mode
inoremap <C-^> <Esc><C-^>

" Reselect pasted text
nnoremap gV `[v`]

" Quickly replace word under the cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>

" Create quickfix list with word under the cursor
nnoremap <Leader>q <Cmd>grep! <cword><CR>
vnoremap <Leader>q "zy<Esc>:grep! <C-r>z<CR>

" Make Y work like D and C
nnoremap Y y$
xnoremap Y <Esc>y$gv

" File jumping
nnoremap [a <Cmd>previous<CR>
nnoremap ]a <Cmd>next<CR>
nnoremap [A <Cmd>first<CR>
nnoremap ]A <Cmd>last<CR>

" Buffer jumping
nnoremap [b <Cmd>bprevious<CR>
nnoremap ]b <Cmd>bnext<CR>
nnoremap [B <Cmd>bfirst<CR>
nnoremap ]B <Cmd>blast<CR>

" Alternative tab jumping
nnoremap [t <Cmd>tabprevious<CR>
nnoremap ]t <Cmd>tabnext<CR>
nnoremap [T <Cmd>tabfirst<CR>
nnoremap ]T <Cmd>tablast<CR>

" Quickfix list jumping
nnoremap [q <Cmd>cprevious<CR>
nnoremap ]q <Cmd>cnext<CR>
nnoremap [Q <Cmd>cfirst<CR>
nnoremap ]Q <Cmd>clast<CR>

" Location list jumping
nnoremap [l <Cmd>lprevious<CR>
nnoremap ]l <Cmd>lnext<CR>
nnoremap [L <Cmd>lfirst<CR>
nnoremap ]L <Cmd>llast<CR>

" Undo break points (add or remove more, according to needs)
for char in [".", ",", "!", "?"]
	call CreateUndoBreakPoint(char)
endfor

" Text objects (add or remove more, according to needs)
for char in [".", ",", ";", ":", "/", "\\", "-", "_", "@", "+", "-", "=", "`"]
	call CreateTextObject(char)
endfor

" Make . to work with visually selected lines
vnoremap . :normal .<CR>.

" Run line as command, output here
noremap Q yyp!!$SHELL<CR>

" Quickly edit the vimrc file
nmap <Leader>v <Cmd>edit $MYVIMRC<CR>

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

" Clipboard copy/paste
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>Y "+y$
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

" Copy the current buffer to the clipboard
nnoremap <Leader><Leader>y <Cmd>%yank+<CR>

" }}}

" Colorscheme {{{

colorscheme default

" Vim does not set the background correctly
if !has("nvim")
	set background=dark
endif
if has("gui_running")
	set background=light
endif

" }}}

" Plugins {{{
let s:plugin_folder = substitute(&packpath, ",.*", "", "")
let s:plugin_folder .= "/pack/minpac/opt/minpac"

if !exists("g:no_vim_plugins")
	if empty(glob(s:plugin_folder))
		call system("git clone https://github.com/k-takata/minpac " . s:plugin_folder)
		autocmd VimEnter * silent! source $MYVIMRC | PackUpdate
	else
		function! PackInit() abort
			packadd minpac
			call minpac#init()
			call minpac#add("k-takata/minpac", {"type": "opt"})

			" Indentation detector
			call minpac#add("tpope/vim-sleuth")

			" Enable dot-repeat for vim-surround
			call minpac#add("tpope/vim-repeat")

			" Surround stuff
			call minpac#add("tpope/vim-surround")

			" Comment stuff
			call minpac#add("tpope/vim-commentary")

			" Git wrapper
			call minpac#add("tpope/vim-fugitive")

			" Vim session wrapper
			call minpac#add("tpope/vim-obsession")

			" Navigate between vim/neovim and tmux
			call minpac#add("christoomey/vim-tmux-navigator")

			" Undo tree
			call minpac#add("mbbill/undotree")

			" If fzf is installed, add companion commands
			call minpac#add("junegunn/fzf", { "do": { -> fzf#install() } })
			call minpac#add("junegunn/fzf.vim")

			" REPL integration
			call minpac#add("jpalardy/vim-slime")
		endfunction

		command! PackUpdate call PackInit() | call minpac#update()
		command! PackClean  call PackInit() | call minpac#clean()
		command! PackStatus call PackInit() | call minpac#status()
	endif
endif

" Plugin configurations for Neovim and Vim with minpac
if exists("g:no_vim_plugins") || ! empty(glob(s:plugin_folder))
	" Fzf
	function! s:build_quickfix_list(lines)
		call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
		copen
		cc
	endfunction

	nnoremap <silent> <expr> <Leader>f (len(system("git rev-parse")) ? ":Files" : ":GFiles")."\<CR>"
	if executable("rg")
		nnoremap <silent> <Leader>j <Cmd>Rg<CR>
	endif

	let g:fzf_action = {
		\ "alt-q": function("s:build_quickfix_list"),
		\ "ctrl-t": "tab split",
		\ "ctrl-s": "split",
		\ "ctrl-v": "vsplit" }
	let g:fzf_buffers_jump = 1
	let g:fzf_layout = { "window": { "width": 0.80, "height": 0.90 } }

	" Vim-slime
	let g:slime_no_mappings = 1
	xmap <Leader>r <Plug>SlimeRegionSend
	nmap <Leader>r <Plug>SlimeParagraphSend
	nnoremap <Leader>R <Cmd>%SlimeSend<CR>

	if !has("nvim")
		let g:slime_target = "vimterminal"
	else
		let g:slime_target = "tmux"
		let g:slime_paste_file = tempname()
		let g:slime_dont_ask_default = 1
		let g:slime_default_config = {
			\ "socket_name": get(split($TMUX, ","), 0),
			\ "target_pane": "{last}" }
	endif
endif
" }}}

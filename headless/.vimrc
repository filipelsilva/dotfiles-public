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

	" Set mouse mode
	set ttymouse=xterm2

	" Enable matchit (extends the use of %)
	runtime! macros/matchit.vim

	" Enable :Man <search>
	runtime! ftplugin/man.vim

endif

" Embed language syntax support
let g:vimsyn_embed="lmpPrt"
let g:markdown_fenced_languages = ["bash", "zsh", "python", "lua", "go", "ruby", "perl"]

" K under cursor uses :Man
set keywordprg=:Man

" Folds (marker = 3*'{')
set foldmethod=marker

" Do splits the "normal" way
set splitright splitbelow

" Search settings
set ignorecase smartcase incsearch hlsearch

" Completion menu settings
set wildmenu wildmode=longest:full,full
set completeopt=menuone,noinsert,noselect

" Backspace settings
set backspace=indent,eol,start

" Indentation settings
set autoindent copyindent shiftround smarttab breakindent
set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" Visual settings
set ruler showcmd linebreak wrap
set laststatus=1 signcolumn=number display=truncate
set listchars=tab:<->,trail:-,nbsp:+,eol:$ shortmess=OtTF

" Motions keep cursor on the same column
set nostartofline

" Spell languages
set spelllang=en,pt

" Diff options
set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

" Make gf (follow file) work with file_name=/path/to/file
set isfname-==

" Don't use octal for <C-x> and <C-a>
set nrformats=bin,hex

" Language may disable some keybinds, stop that
set nolangremap

" If rg exists, use it
if executable("rg")
	set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
	set grepformat=%f:%l:%c:%m,%f:%l:%m
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

" SearchWords {{{
function! SearchWords(search) abort
	if executable("rg")
		execute "grep! " . shellescape(a:search) . " ."
	else
		execute "grep! -R -I --exclude-dir=\".git\" " . shellescape(a:search) . " ."
	endif
	if len(getqflist()) != 0
		copen
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
	for mode in ['xnoremap', 'onoremap']
		execute mode . " <silent> i" . a:char . " :<C-u>normal! T" . a:char . "vt" . a:char . "<CR>"
		execute mode . " <silent> a" . a:char . " :<C-u>normal! F" . a:char . "vf" . a:char . "<CR>"
	endfor
endfunction
" }}}

" HeaderToDefinition (c/cpp only) {{{
function! HeaderToDefinition() abort
	let l:filename = fnameescape(expand("%:.:r"))
	let l:new_extensions = []
	let l:extension = expand("%:e")

	if l:extension ==# "c" || l:extension ==# "cpp"
		call add(l:new_extensions, ".h")
		call add(l:new_extensions, ".hpp")
	elseif l:extension ==# "h" || l:extension ==# "hpp"
		call add(l:new_extensions, ".c")
		call add(l:new_extensions, ".cpp")
	endif

	for new_extension in l:new_extensions
		let l:file_try = l:filename . new_extension
		if !empty(glob(l:file_try))
			execute "edit " . l:file_try
		endif
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
" }}}

" }}}

" Commands {{{

" Cd to where the current file is edited (changes only for the current window)
command! CDC lcd %:p:h

" Diff between the current buffer and the file it was loaded from
command! DiffOrig vertical new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis

" SearchWords
command! -nargs=1 SearchWords call SearchWords(<f-args>)

" TrimWhitespace
command! TrimWhitespace call TrimWhitespace()

" CreateUndoBreakPoint
command! -nargs=1 CreateUndoBreakPoint call CreateUndoBreakPoint(<f-args>)

" CreateTextObject
command! -nargs=1 CreateTextObject call CreateTextObject(<f-args>)

" HeaderToDefinition
command! HeaderToDefinition call HeaderToDefinition()

" OSC52Yank
command! OSC52Yank call OSC52Yank()

" }}}

" Autocommands {{{
augroup Vimrc
	autocmd!

	" Load vimrc after saving it
	autocmd BufWritePost $MYVIMRC source % | echomsg "Reloaded " . $MYVIMRC

	" Go to last edited position on open file
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !~# "commit" | execute "normal! g'\"" | endif

	" If vim window is resized, resize the splits within
	autocmd VimResized * wincmd =

	" Change formatoptions everywhere
	autocmd FileType * setlocal formatoptions=tcqj

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

augroup ColorschemeOverrides
	autocmd!

	" Colorscheme changes
	autocmd VimEnter,Colorscheme * call clearmatches() | highlight! link Character80 ColorColumn | call matchadd("Character80", '\%80v.')

augroup END
" }}}

" Keymaps {{{

" <Leader> key bind
let mapleader = "\<Space>"

" Easier completion menus
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Easier navigation in splits
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Easier navigation in splits for the integrated terminal
tnoremap <C-h> <C-\><C-n><C-w><C-h>
tnoremap <C-j> <C-\><C-n><C-w><C-j>
tnoremap <C-k> <C-\><C-n><C-w><C-k>
tnoremap <C-l> <C-\><C-n><C-w><C-l>

" Zoom and unzoom pane
noremap <Leader>z <C-w>_<Bar><C-w>\|
noremap <Leader>Z <C-w>=

" Change binds for Esc inside terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

" Toggle numbers
nnoremap <silent> <Leader>n :set invnumber invrelativenumber<CR>

" Toggle spell
nnoremap <silent> <Leader>l :set invlist<CR>

" Disable highlighting
nnoremap <Leader>, <Cmd>nohlsearch<CR>

" Jump to file with same name but another extension
nnoremap <Leader>h :edit <C-r>=fnameescape(expand("%:.:r"))<CR>.

" Jump to header file and back (only works in c/cpp files)
nnoremap <silent> <Leader><Leader>h :HeaderToDefinition<CR>

" File jumping
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>

" Buffer jumping
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
inoremap <C-^> <Esc><C-^>

" Alternative tab jumping
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>
nnoremap [T :tabfirst<CR>
nnoremap ]T :tablast<CR>

" Quickfix list jumping
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>

" Reselect pasted text
nnoremap gV `[v`]

" Like o and O but stays on cursor
nnoremap <silent> ]<Space> :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> [<Space> :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

" Substitute word under cursor ('s': wherever | 'S': word only)
nnoremap <Leader>s :%s/<C-r><C-w>//g<Left><Left>
vnoremap <Leader>s "zy<Esc>:%s/<C-r>z//g<Left><Left>
nnoremap <Leader>S :%s/\<<C-r><C-w>\>//g<Left><Left>
vnoremap <Leader>S "zy<Esc>:%s/\<<C-r>z\>//g<Left><Left>

" Search for word quickly
nnoremap <Leader>r :SearchWords<Space>

" Create quickfix list with searched word
nnoremap <Leader>q :SearchWords <cword><CR>
vnoremap <Leader>q "zy<Esc>:SearchWords <C-r>z<CR>

" Open files quickly
nnoremap <Leader>f :edit $PWD/
nnoremap <Leader><Leader>f :edit $HOME/
nnoremap <Leader>F :edit <C-r>=expand("%:p:h") . "/"<CR>

" Make Y work like D and C
nnoremap Y y$
xnoremap Y <Esc>y$gv

" Undo break points (add or remove more, according to needs)
for char in [".", ",", "!", "?"]
	call CreateUndoBreakPoint(char)
endfor

" Text objects (add or remove more, according to needs)
for char in [".", ",", ";", ":", "/", "\\", "-", "_", "@", "+", "-", "=", "`"]
	call CreateTextObject(char)
endfor

" Add <number>[jk] to jumplists
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . "j"
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . "k"

" Move blocks of code
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Make . to work with visually selected lines
vnoremap . :normal .<CR>

" Run line as command, output here
noremap Q yyp!!$SHELL<CR>

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

" }}}

" Colorscheme {{{

colorscheme default

" Vim does not set the background correctly
if !has("nvim")
	set background=dark
endif

" }}}

" Fzf {{{
if executable("fzf")
	" Create quickfix list out of selected files
	function! s:build_quickfix_list(lines)
		call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
		copen
		cc
	endfunction

	" Remake keybinds for terminal to keep fzf in mind
	tnoremap <expr> <C-h> (&filetype == "fzf") ? "<C-h>" : "<C-\><C-n><C-w><C-h>"
	tnoremap <expr> <C-j> (&filetype == "fzf") ? "<C-n>" : "<C-\><C-n><C-w><C-j>"
	tnoremap <expr> <C-k> (&filetype == "fzf") ? "<C-p>" : "<C-\><C-n><C-w><C-k>"
	tnoremap <expr> <C-l> (&filetype == "fzf") ? "<C-l>" : "<C-\><C-n><C-w><C-l>"
	tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<C-\><C-n>"
	tnoremap <expr> <C-v><Esc> (&filetype == "fzf") ? "<C-v><Esc>" : "<Esc>"

	" Mappings
	nnoremap <silent> <expr> <Leader>f (len(system("git rev-parse")) ? ":Files" : ":GFiles")."\<CR>"
	nnoremap <silent> <Leader>F :Files <C-r>=substitute(expand("%:p:h"), " ", "\\\\ ", "g")<CR><CR>
	nnoremap <silent> <Leader><Leader>f <Cmd>Files $HOME<CR>
	if executable("rg")
		nnoremap <silent> <Leader>r <Cmd>Rg<CR>
	endif
	nnoremap <silent> <Leader>j <Cmd>Buffers<CR>

	" Environment variable
	if empty($FZF_DEFAULT_OPTS)
		let $FZF_DEFAULT_OPTS = "--layout=reverse --info=inline --bind 'ctrl-a:toggle-all'"
	endif

	" Settings
	let g:fzf_action = {
		\ "alt-q": function("s:build_quickfix_list"),
		\ "ctrl-t": "tab split",
		\ "ctrl-s": "split",
		\ "ctrl-v": "vsplit" }
	let g:fzf_buffers_jump = 1
endif
" }}}

" ToggleSearchHighlight {{{
function! StartSearchHighlight() abort
	let s:pos = match(getline('.'), @/, col('.') - 1) + 1
	if s:pos != col('.')
		call StopSearchHighlight()
	endif
endfunction

function! StopSearchHighlight() abort
	if !v:hlsearch || mode() isnot 'n'
		return
	else
		silent call feedkeys("\<Plug>(StopSearchHighlight)", 'm')
	endif
endfunction

augroup ToggleSearchHighlight
	autocmd!

	" After some cursor movement, remove highlighting from text
	autocmd CursorMoved * call StartSearchHighlight()
	autocmd InsertEnter * call StopSearchHighlight()

augroup END

" Disable hlsearch right after moving
noremap <expr> <Plug>(StopSearchHighlight) execute("nohlsearch")[-1]
noremap! <expr> <Plug>(StopSearchHighlight) execute("nohlsearch")[-1]
" }}}

" Plugins {{{
if !exists("g:no_vim_plugins")
	let s:plugin_folder = substitute(&packpath, ",.*", "", "")
	let s:plugin_folder .= "/pack/minpac/opt/minpac"
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

			" Surround stuff
			call minpac#add("tpope/vim-surround")

			" Comment stuff
			call minpac#add("tpope/vim-commentary")

			" If fzf is installed, add companion commands
			if executable("fzf")
				call minpac#add("junegunn/fzf.vim")
			endif
		endfunction

		command! PackUpdate call PackInit() | call minpac#update()
		command! PackClean  call PackInit() | call minpac#clean()
		command! PackStatus call PackInit() | call minpac#status()
	endif
endif
" }}}

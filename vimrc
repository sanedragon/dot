"##### general settings #####

set nocompatible
set encoding=utf-8
set number
"if exists('+relativenumber')
"	set relativenumber
"endif
if has('unnamedplus')
	set clipboard=unnamedplus
endif
set numberwidth=4
set ruler
if has('persistent_undo')
	set undodir=~/.vim/local/undo/
	set undofile
	set undolevels=100000
	if exists('+undoreload')
		set undoreload=100000
	endif
endif
if exists('+cryptmethod')
	set cryptmethod=blowfish
endif
let mapleader = ","
"set digraph
set modeline
set gdefault
set magic
set showmode
set showcmd
set showmatch
set matchtime=5
set history=100
set notitle
set ttyfast
"set ttyscroll=0
set scrolloff=3
set nostartofline
set backup
set backupdir=~/.vim/local/backup/
set directory=~/.vim/local/
set autowrite
set backspace=indent,eol,start
set splitbelow
if has('mouse')
	set mouse=a
	set mousemodel=popup_setpos
	map <F10> :set paste<CR>
	map <F11> :set nopaste<CR>
	imap <F10> <C-O>:set paste<CR>
	imap <F11> <nop>
	set pastetoggle=<F11>
endif
set viminfo^=%
filetype plugin indent on
set ofu=syntaxcomplete#Complete
"set spell
"set spelllang=en_us

"##### appearance #####

set t_Co=256
set background=dark
colorscheme tomorrow-night-eighties
if exists('+colorcolumn')
	set colorcolumn=80,120
endif
set showtabline=0
syntax on
let loaded_matchparen = 0
set cursorline
"set cursorcolumn
"let g:Powerline_symbols = 'fancy'
set fillchars+=fold:\─,diff:\─,vert:\│,stl:\ ,stlnc:\

"##### whitespace #####

set nowrap
set whichwrap+=<>[]
set textwidth=80
"set formatoptions=tcqron1
"set lbr
"set showbreak=→
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set expandtab
set list listchars=tab:▸\ ,trail:·",eol:¬
filetype indent on
set virtualedit=onemore

"##### folding #####

set foldenable
set foldmethod=manual
set foldlevel=100 " Don't autofold anything
"augroup vimrc
"    au BufReadPre * setlocal foldmethod=syntax
"    au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
"augroup END

"##### searching #####

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

"##### tab completion #####

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,*.pyc,*.DS_Store,*.db

"##### status bar #####

set laststatus=2
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

"##### keyboard mappings #####

" NERDTreeToggle
noremap <leader>n :NERDTreeToggle<CR>

" clean trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" hardwrap a paragraph
nnoremap <leader>q gqip

" reselect what was just pasted
nnoremap <leader>v V`]

" quickly open .vimrc as split window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" toggle special characters
nmap <leader>l :set invlist!<CR>
nmap <leader>p :set invpaste!<CR>

" useful from RTK
map <leader>ca :!~/usealiases<CR>
map <leader>b :BufExplorer<cr>

" ack
nnoremap <leader>a :Ack

" convenient mappings (TODO: what about insert mode?)
"noremap <C-a> ggVG
"nnoremap <C-x> "+d
"noremap <C-c> "+y<CR>
"noremap <C-v> "+p<CR>

" Prev/Next Buffer
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

" easier split window
nnoremap <leader>w <C-w>s<C-w>k

" scroll shortcuts
nmap <C-h> zH
nmap <C-l> zL
nmap <C-j> <C-d>
nmap <C-k> <C-u>

" highlight search matches
nmap <F3> :set hls!<CR>

" clear old search
nnoremap <leader>/ :let @/ = ""<CR>

" display unprintable characters
nnoremap <F2> :set list!<CR>

" insert date
nnoremap <F5> "=strftime("%d %b %Y %H:%M:%S")<CR>P
inoremap <F5> <C-R>=strftime("%d %b %Y %H:%M:%S")<CR>

" highlight cursor's current column
map <F6> :set cursorcolumn!<CR>

" replacing (local, global)
"nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>
"nnoremap gR gD:%s/<C-R>///gc<left><left><left>

function! Refactor()
    call inputsave()
    let @z=input("What do you want to rename '" . @z . "' to? ")
    call inputrestore()
endfunction

" Locally (local to block) rename a variable
nmap <Leader>rf "zyiw:call Refactor()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" folding (if enabled)
inoremap <F7> <C-O>za
nnoremap <F7> za
onoremap <F7> <C-C>za
vnoremap <F7> zf
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

" Make C-w o (only window) reversible by opening a tab
nnoremap <C-W>O :tabnew %<CR>
nnoremap <C-W>o :tabnew %<CR>
nnoremap <C-W><C-O> :tabnew %<CR>

" Text object for indented code
onoremap <silent>ai :<C-u>call IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>call IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-u>call IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>call IndTxtObj(1)<CR><Esc>gv
function! IndTxtObj(inner)
	if &filetype == 'haml' || &filetype == 'sass' || &filetype == 'python'
		let meaningful_indentation = 1
	else
		let meaningful_indentation = 0
	endif
	let curline = line(".")
	let lastline = line("$")
	let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
	let i = i < 0 ? 0 : i
	if getline(".") =~ "^\\s*$"
		return
	endif
	let p = line(".") - 1
	let nextblank = getline(p) =~ "^\\s*$"
	while p > 0 && (nextblank || indent(p) >= i )
		-
		let p = line(".") - 1
		let nextblank = getline(p) =~ "^\\s*$"
	endwhile
	if (!a:inner)
		-
	endif
	normal! 0V
	call cursor(curline, 0)
	let p = line(".") + 1
	let nextblank = getline(p) =~ "^\\s*$"
	while p <= lastline && (nextblank || indent(p) >= i )
		+
		let p = line(".") + 1
		let nextblank = getline(p) =~ "^\\s*$"
	endwhile
	if (!a:inner && !meaningful_indentation)
		+
	endif
	normal! $
endfunction

" git blame
vmap <leader>bl :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

inoremap <tab> <c-r>=InsertTabWrapper("forward")<CR>
inoremap <s-tab> <c-r>=InsertTabWrapper("backward")<CR>
inoremap <c-tab> <c-r>=InsertTabWrapper("startkey")<CR>
" Remap TAB to keyword completion
function! InsertTabWrapper(direction)
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	elseif "backward" == a:direction
		return "\<c-p>"
	elseif "forward" == a:direction
		return "\<c-n>"
	else
		return "\<c-x>\<c-k>"
	endif
endfunction

" block select with right-click-and-drag
noremap <RightMouse> <LeftMouse><Esc><C-V>
noremap <RightDrag> <LeftDrag>

"##### auto commands #####

if has('autocmd')
	" settings immediately take effect
	augroup vimrc
		au!
		au BufWritePost ~/.vimrc :source ~/.vimrc
		au BufLeave ~/.vimrc :source ~/.vimrc
	augroup END

    augroup redraw
        au!
        au VimResized * redraw!
    augroup END

	augroup focus
		au!
		au FocusLost * :wa
	augroup END

	augroup dir
		au!
		au BufEnter * cd %:p:h
	augroup END

	augroup lastcursorpos
		au!
		au BufReadPost *
					\ if line("'\"") > 0 && line ("'\"") <= line("$")	|
					\   exe "normal! g'\""								|
					\ endif
	augroup END

	augroup nerdtree
		au!
		au BufEnter *
					\ if exists("t:NERDTreeBufName")			|
					\	if bufwinnr(t:NERDTreeBufName) != -1	|
					\		if winnr("$") == 1					|
					\			q								|
					\		endif								|
					\	endif									|
					\ endif
	augroup END
endif

"##### RTK-specific #####

if filereadable('/usr/local/etc/vimrc_files/reasonably_stable_mappings.vim')
	source /usr/local/etc/vimrc_files/reasonably_stable_mappings.vim
endif

" keep at bottom
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


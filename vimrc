" =============================================================================
" Pathogen (initial setup)
" =============================================================================

" settings

let g:pathogen_disabled = []
if v:version < 702
    let g:pathogen_disabled += ['tagbar', 'neocomplcache', 'jedi-vim']
endif

" bring in Pathogen

runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

" fix up rtp a bit to exclude rusty old default scripts if they exist

let list = []
for dir in pathogen#split(&rtp)
    if dir !~# '/usr/share/vim/vimfiles'
        call add(list, dir)
    endif
endfor
let &rtp = pathogen#join(list)


" =============================================================================
" general settings
" =============================================================================

set nocompatible
set encoding=utf-8
set shortmess+=I
set completeopt+=preview,menu
set number
"if exists('+relativenumber')
"    set relativenumber
"endif
set numberwidth=4
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
set history=5000
set notitle
set ttyfast
"set ttyscroll=0
set scrolloff=3
set sidescrolloff=5
set nostartofline
"set backup
"set backspace=indent,eol,start
set splitbelow
if has('mouse')
    set mouse=a
    set mousemodel=popup_setpos
endif
set viminfo^=%
"filetype plugin indent on
"set spell


" =============================================================================
" appearance
" =============================================================================

set t_Co=256
set background=dark
colorscheme tomorrow-night-eighties
set guifont=Inconsolata:h13
set cursorline
"set cursorcolumn
"if exists('+colorcolumn') | set colorcolumn=50,72,80,120 | endif

" using vim-sensible
"set fillchars+=fold:\·,diff:\·,vert:\ ,stl:\ ,stlnc:\
"set list listchars=tab:▸\ ,trail:·",eol:¬
"set showbreak=→

"syntax enable


" =============================================================================
" highlights
" =============================================================================

hi clear ColorColumn
hi link ColorColumn CursorLine

hi currentLine term=reverse cterm=reverse gui=reverse
hi breakPoint  term=NONE    cterm=NONE    gui=NONE
hi empty       term=NONE    cterm=NONE    gui=NONE

sign define currentLine linehl=currentLine
sign define breakPoint  linehl=breakPoint  text=>>
sign define both        linehl=currentLine text=>>
sign define empty       linehl=empty


" =============================================================================
" formatting
" =============================================================================

set nowrap
"set whichwrap+=<>[]
"set textwidth=80
"set formatoptions=tcqron1
"set lbr
"set smartindent
"set smarttab
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
"set expandtab
"filetype indent on
set virtualedit+=block,onemore


" =============================================================================
" clipboard
" =============================================================================

set clipboard=unnamed,unnamedplus


" =============================================================================
" undo
" =============================================================================

if has('persistent_undo')
"    set undodir=~/.vim/local/undo/ " set by sensible
    set undofile
    set undolevels=1000
    if exists('+undoreload')
        set undoreload=10000
    endif
endif


" =============================================================================
" folding
" =============================================================================

set foldenable
set foldmethod=manual
set foldlevel=100 " Don't autofold anything


" =============================================================================
" searching
" =============================================================================

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


" =============================================================================
" spelling
" =============================================================================

"set spell
set spelllang=en_us


" =============================================================================
" menu
" =============================================================================

set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,*.pyc,*.DS_Store,*.db


" =============================================================================
" status bar
" =============================================================================

if has('statusline')
    set laststatus=2
    set statusline=%<%f\ " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y] " filetype
    set statusline+=\ [%{getcwd()}] " current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
endif


" =============================================================================
" status bar
" =============================================================================

if has('cmdline_info')
    set ruler " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd " show partial commands in status line and selected characters/lines in visual mode
endif


" =============================================================================
" keyboard mappings
" =============================================================================

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

nnoremap <silent> } :let @1=@/<CR>/^\s*$<CR>:nohls<CR>:let @/=@1<CR>:set hls<CR>
nnoremap <silent> { :let @1=@/<CR>?^\s*$<CR>:nohls<CR>:let @/=@1<CR>:set hls<CR>

" folding (if enabled)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

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

" Prev/Next Buffer
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

" scroll shortcuts
nmap <C-h> zH
nmap <C-l> zL
nmap <C-j> <C-d>
nmap <C-k> <C-u>


" clear old search
nnoremap <leader>/ :let @/ = ""<CR>

" display unprintable characters
nnoremap <F2> :set list!<CR>

" toggle spellcheck
nnoremap <F4> :set spell!<CR>

" toggle paste mode
nnoremap <F5> :set invpaste!<CR>
set pastetoggle=<F5>

" Locally (local to block) rename a variable
function! Refactor()
    call inputsave()
    let @z=input("What do you want to rename '" . @z . "' to? ")
    call inputrestore()
endfunction
nnoremap <Leader>rf "zyiw:call Refactor()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" Increment a visual selection (like a column of numbers)
function! Incr()
    let a = line('.') - line("'<")
    let c = virtcol("'<")
    if a > 0
        execute 'normal! '.c.'|'.a."\<C-a>"
    endif
    normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

" block select with middle-click-and-drag
noremap <MiddleMouse> <LeftMouse><Esc><C-V>
noremap <MiddleDrag> <LeftDrag>


" =============================================================================
" auto commands
" =============================================================================

if has('autocmd')
    " settings immediately take effect
    augroup instantsettings
        au!
        au BufWritePost ~/.vimrc :source ~/.vimrc
        au BufLeave ~/.vimrc :source ~/.vimrc
    augroup END

    augroup redrawonresize
        au!
        au VimResized * redraw!
    augroup END

    augroup rememberlastcursorpos
        au!
        au BufReadPost *
                    \ if line("'\"") > 0 && line ("'\"") <= line("$")   |
                    \   exe "normal! g'\""                              |
                    \ endif
    augroup END

    if filereadable(expand("$HOME/bin/touch_handler_cgis"))
        augroup touchhandlers
            au!
            au BufWritePost * let output = system(expand("$HOME/bin/touch_handler_cgis"))
        augroup END
    endif
endif


" =============================================================================
" RTK
" =============================================================================

if filereadable('/usr/local/etc/vimrc_files/reasonably_stable_mappings.vim')
    source /usr/local/etc/vimrc_files/reasonably_stable_mappings.vim
endif

" workarounds
au! BufEnter *
let $TEST_DB=1


" =============================================================================
" NERDTree settings
" =============================================================================

noremap <leader>n :NERDTreeToggle<CR>
noremap <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
"noremap <leader>e :NERDTreeFind<CR>
"noremap <leader>nt :NERDTreeFind<CR>

let NERDTreeHijackNetrw=1
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0


" =============================================================================
" CtrlP settings
" =============================================================================

noremap <leader>p :CtrlP<CR>
noremap <leader>b :CtrlPBuffer<CR>


" =============================================================================
" TagBar settings
" =============================================================================

noremap <leader>t :TagbarToggle<CR>
noremap <F8> :TagbarToggle<CR>

if filereadable(expand('~/.local/bin/ctags'))
    let g:tagbar_ctags_bin = expand('~/.local/bin/ctags')
endif
let g:tagbar_autoclose = 0


" =============================================================================
" Jedi-vim settings
" =============================================================================

let g:jedi#squelch_py_warning = 1


" =============================================================================
" Tabular
" =============================================================================

nnoremap   <Leader>a        :Tabularize   / /<CR>
vnoremap   <Leader>a        :Tabularize   / /<CR>

nnoremap   <Leader>a&       :Tabularize   /&<CR>
vnoremap   <Leader>a&       :Tabularize   /&<CR>

nnoremap   <Leader>a=       :Tabularize   /=<CR>
vnoremap   <Leader>a=       :Tabularize   /=<CR>

nnoremap   <Leader>a:       :Tabularize   /:<CR>
vnoremap   <Leader>a:       :Tabularize   /:<CR>

nnoremap   <Leader>a::      :Tabularize   /:\zs<CR>
vnoremap   <Leader>a::      :Tabularize   /:\zs<CR>

nnoremap   <Leader>a,       :Tabularize   /,<CR>
vnoremap   <Leader>a,       :Tabularize   /,<CR>

nnoremap   <Leader>a<Bar>   :Tabularize   /<Bar><CR>
vnoremap   <Leader>a<Bar>   :Tabularize   /<Bar><CR>


" =============================================================================
" NeoComplCache settings
" =============================================================================

"let g:neocomplcache_enable_at_startup = 0
" Use smartcase.
"let g:neocomplcache_enable_smart_case = 1
"" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
"" Use underscore completion.
"let g:neocomplcache_enable_underbar_completion = 1
"" Sets minimum char length of syntax keyword.
"let g:neocomplcache_min_syntax_length = 3

"" Enable omni completion
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType perl setlocal omnifunc=perlcomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"" Recommended key-mappings.
"" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
"" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()

"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"


" =============================================================================
" Solarized settings
" =============================================================================

let g:solarized_termcolors = 256
let g:solarized_style      = "dark"

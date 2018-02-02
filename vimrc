" Variated from sublee's:
" https://github.com/sublee/subenv/blob/master/vimrc

" vim:ft=vim:et:ts=2:sw=2:sts=2:

set nocp
set nu!

call plug#begin('~/.vim/plugged')
" plugins ---------------------------------------------------------------------

" Syntax highlighters
Plug 'plasticboy/vim-markdown'
Plug 'Jinja'
Plug 'othree/html5.vim'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'ekalinin/Dockerfile.vim'

" Function extensions
Plug 'rhysd/committia.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'simnalamburt/vim-mundo'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'w0rp/ale'
"Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'skywind3000/asyncrun.vim'
Plug 'wincent/command-t'

" Color themes
Plug 'joshdick/onedark.vim'

" -----------------------------------------------------------------------------
call plug#end()

" Syntax highlighting.
syntax on

" Softtab -- use spaces instead tabs.
set expandtab
set tabstop=4 shiftwidth=4 sts=4
set autoindent
highlight HardTab term=underline cterm=underline
autocmd BufWinEnter * 2 match HardTab /\t\+/

" Prefer "very magic" regex.
nnoremap / /\v
cnoremap %s/ %s/\v

" Search for visually selected text by //.
vnoremap // y/<C-R>"<CR>

" I dislike CRLF.
set fileformat=unix

" Clipboard
set clipboard=unnamed

" Mouse
set mouse=a

" Make backspace works like most other applications.
set backspace=2

" Detect modeline hints.
set modeline

" Prefer UTF-8.
set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp949,korea,iso-2022-kr

" Ignore case in searches.
set ignorecase

" Highlight searching keyword.
set hlsearch
highlight Search term=inverse cterm=none ctermbg=cyan

" Keep 80 columns and dense lines.
set colorcolumn=81
highlight ColorColumn term=underline cterm=underline ctermbg=none
"autocmd BufWinEnter * match Error /\%>80v.\+\|\s\+$\|^\s*\n\+\%$/

" Some additional syntax highlighters.
au! BufRead,BufNewFile *.wsgi setfiletype python
au! BufRead,BufNewFile *.sass setfiletype sass
au! BufRead,BufNewFile *.haml setfiletype haml
au! BufRead,BufNewFile *.less setfiletype less
au! BufRead,BufNewFile *go setfiletype golang
au! BufRead,BufNewFile *rc setfiletype conf
au! BufRead,BufNewFile *.*_t setfiletype jinja

" These languages have their own tab/indent settings.
au FileType cpp        setl ts=2 sw=2 sts=2
au FileType javascript setl ts=2 sw=2 sts=2
au FileType ruby       setl ts=2 sw=2 sts=2
au FileType xml        setl ts=2 sw=2 sts=2
au FileType yaml       setl ts=2 sw=2 sts=2
au FileType html       setl ts=2 sw=2 sts=2
au FileType htmldjango setl ts=2 sw=2 sts=2
au FileType lua        setl ts=2 sw=2 sts=2
au FileType haml       setl ts=2 sw=2 sts=2
au FileType css        setl ts=2 sw=2 sts=2
au FileType sass       setl ts=2 sw=2 sts=2
au FileType less       setl ts=2 sw=2 sts=2
au Filetype rst        setl ts=3 sw=3 sts=3
au FileType golang     setl noet
au FileType make       setl ts=4 sw=4 sts=4 noet

" Markdown-related configurations.
augroup mkd
  autocmd BufRead *.markdown set formatoptions=tcroqn2 comments=n:> spell
  autocmd BufRead *.mkdn     set formatoptions=tcroqn2 comments=n:> spell
  autocmd BufRead *.mkd      set formatoptions=tcroqn2 comments=n:> spell
augroup END

" English spelling checker.
setlocal spelllang=en_us

" Pathogen
silent! call pathogen#infect()

" Mundo
autocmd VimEnter *
\ if exists(':Mundo')
\|  nnoremap <F5> :MundoToggle<CR>
\|endif

" YouCompleteMe
autocmd VimEnter *
\ if exists('g:ycm_goto_buffer_command')
\|  nnoremap <F12> :YcmCompleter GoToDefinitionElseDeclaration<CR>
\|endif

" Explore the directory of the current file by `:E`.
cabbrev E e %:p:h

" Disable Markdown folding.
let g:vim_markdown_folding_disabled=1

" Customize colors for Jinja syntax.
hi def link jinjaVarBlock Comment

" Quickfix window will open when something adds to it
augroup vimrc
    autocmd QuickFixCmdPost * botright copen 8
augroup END

" Color
colorscheme onedark

" Use ESC to close command-T
"if &term =~ "xterm" || &term =~ "screen"
"    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
"endif

set noswapfile

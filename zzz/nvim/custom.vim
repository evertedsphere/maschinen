set nocompatible

filetype plugin indent on
syntax on

"https://vim.fandom.com/wiki/Example_vimrc
set hidden
set wildmenu
set showcmd
set hlsearch
set nomodeline
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
"set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set mouse=a
set cmdheight=2
set nonumber
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set shiftwidth=2
set softtabstop=2
set expandtab

packloadall


if (has("termguicolors"))
  set termguicolors
  let g:onedark_termcolors=256
endif

let g:onedark_hide_endofbuffer=1
let g:onedark_terminal_italics=1
set background=dark
colorscheme onedark

hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE

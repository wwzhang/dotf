set showmode
set showcmd
set ruler
set number
"#set mouse=a
set ffs=unix,mac,dos 
filetype indent on  
filetype plugin on
syntax on 
set report=0
set showmatch
set laststatus=2
set backspace=indent,eol,start
set fileencodings=ucs-bom,utf-8,gbk,gb18030,gb2312,prc,big-5,euc-jp,euc-kr
set encoding=utf-8
"set encoding=gb2312
set wildmode=list:longest,full
"set nomodeline
set modelines=5
filetype on
filetype plugin on
filetype indent on
set grepprg=grep\ -nH\ $*
let IspellLang = 'english'
let PersonalDict = '~/.ispell_' . IspellLang
abbreviate teh the
set autoindent
set smartindent
set ignorecase
let color = "true"
set background=dark
"set term=builtin_beos-ansi
"set term=xterm-color
colorscheme vividchalk 
if version >= 603
	set helplang=cn
endif
set gfn=Monaco:h12
set columns=100
set wildmode=list:full
set wildmenu
set backspace=2
"##VIM 7 features
set spell
"setlocal spell spelllang=en_us
"set spl=en_us spell

set wildmenu
set wildmode=list:longest
""set filetype plugin on

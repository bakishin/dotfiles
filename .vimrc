set nobackup
set shiftwidth=4
set ambiwidth=double
set softtabstop=4
set tabstop=4
set expandtab
set showmatch
set magic
set ignorecase
set smartcase
set hlsearch
set incsearch
syntax on
set history=80
set encoding=utf-8
set fileencodings=utf-8
"colorscheme desert
colorscheme mycolor
set autoindent
set tabstop=4

 

"----------------------------------------------------------+
" ステータスライン |
"----------------------------------------------------------+
 

" ステータスラインを常に表示,色変更
set laststatus=2
"hi StatusLine ctermfg=White ctermbg=Blue cterm=none
hi StatusLine ctermfg=White ctermbg=DarkBlue cterm=none
au InsertEnter * hi StatusLine ctermfg=Black ctermbg=yellow cterm=none
au InsertLeave * hi StatusLine ctermfg=White ctermbg=DarkGreen cterm=none
set statusline=%F:\ \ %{GetFunc()}%=%l/%L%11p%%
 

autocmd BufEnter,BufWritePost * call ErrorCheckStatusline()
 

" function行の取得用の関数
function! GetFunc()
let s:path = expand('%:p')
let s:ext = expand('%:e')
if s:ext == "php"
let start = search("function",'bn')
elseif &filetype == "vim"
let start = search("function!",'bn')
elseif &filetype == "py"
let start = search("def",'bn')
else
let start = ""
endif
 

let lines = getline(start)
return lines
endfunction
 

" エラー時のステータスライン変更用関数
function! ErrorCheckStatusline()
 

" エラー時の色定義
let l:ecol = 'highlight StatusLine ctermfg=Yellow ctermbg=Red cterm=none'
"
if ! exists('g:is_error')
" 通常時の色定義
let s:fg = synIDattr( hlID( "StatusLine" ) , "fg" )
let s:bg = synIDattr( hlID( "StatusLine" ) , "bg" )
let g:ncol = 'highlight StatusLine ctermfg='.s:fg.' ctermbg='.s:bg.' cterm=none'
endif
 

" チェックを実行(PHP)
if &filetype == "php"
let l:tmp = system("php -l ".bufname(""))
 

" エラーがあった場合
if ! (l:tmp =~ "No syntax errors" )
let g:is_error = 1
let g:status = split(l:tmp, '\n')
silent exec 'set statusline=%{g:status[0]}%=%c,%l%11p%%'
silent exec l:ecol
return
else
let g:is_error = 0
endif
 


" チェックを実行(python)
elseif &filetype == "python"
let l:tmp = system("pyflakes ".bufname(""))
 

" エラーがあった場合
if ! (l:tmp == "" )
let g:is_error = 1
let g:status = split(l:tmp, '\n')
silent exec 'set statusline=%{g:status[0]}%=%c,%l%11p%%'
silent exec l:ecol
return
else
let g:is_error = 0
endif
 

endif
 

" 通常のステータスラインを表示
silent exec 'set statusline=%F,\ \ %{GetFunc()}%=%l/%L%11p%%'
silent exec g:ncol
return
endfunction
 

" ctags 設定
au BufNewFile,BufRead *.php set tags+=$HOME/.tags
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
" viを起動する位置で読むtags ファイルを変える
let current_dir = expand("%:p:h")
 


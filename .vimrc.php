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
endif:

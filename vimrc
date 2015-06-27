"起動時メッセージ非表示
set shortmess+=I

"ヘルプ画面最大
set helpheight=999

" 文字コード自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-ms対応チェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213対応チェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodings構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語含まない fileencoding に encoding を使う
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コード自動認識
set fileformats=unix,dos,mac
" □と◯◯カーソル位置ずれないい
if exists('&ambiwidth')
  set ambiwidth=double
endif

"viとの互換性をとらない
set nocompatible

"改行コード自動認識
set fileformats=unix,dos,mac

"カラースキーム
colorscheme RailsCasts

"シンタックスハイライト有効
 syntax on

"行番号を表示
set number

"編集行番号ハイライト
hi CursorLineNr term=bold cterm=NONE ctermfg=228 ctermbg=NONE

"タイトルウインドウ枠
set title

"ルーラー表示
set ruler

"編集業横線表示
set cursorline

"編集業縦線ハイライト
"set cursorcolumn
"hi CursorColumn term=reverse  ctermbg=5

"カーソル位置記憶
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

"対応括弧強調
set showmatch

"検索文字列ハイライト有効
set hlsearch

"インクリメンタルサーチ有効
set incsearch

"検索最終候補時先頭へ
set wrapscan

"コマンドライン補完拡張
set wildmenu wildmode=list:longest,full

"コマンドライン履歴保存
set history=50

"入力テキスト最大幅
set textwidth=0

"ウインドウ幅折り返し
set wrap

"バックスペース有効範囲
set backspace=indent,eol,start

"全角スペース表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

"オートインデント有効
set autoindent

"スマートインデント有効
set smartindent

"タブ対応空白数
set tabstop=4

"インデント各階段空白数
set shiftwidth=4

"タブ時空白なし
set noexpandtab

"上下視界確保
set scrolloff=8

"保存確認
set confirm

"保存前別ファイル開く
set hidden

" 外部変更読み直し
set autoread

"バックアップなし
set nobackup

"スワップなし
set noswapfile

"windowsパス
set shellslash

"ビープ音無効
set visualbell t_vb=


"デフォルト
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

"プラグイン


"NeoBundle


"bundle管理ディレクトリ

" neobundle settings {{{
if has('vim_starting')
  set nocompatible
  " neobundle をインストールしていない場合は自動インストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    " vim からコマンド呼び出しているだけ neobundle.vim のクローン
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath の追加は必須
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

"neobundleをneobundle管理
NeoBundleFetch 'shougo/neobundle.vim'

"プラグイン管理

"railscasts
NeoBundle 'jpo/vim-railscasts-theme'
"molokai
NeoBundle 'tomasr/molokai'
"NERDTree
NeoBundle 'scrooloose/nerdtree'
"autoclose
NeoBundle 'Townk/vim-autoclose'
"Emmet
NeoBundle 'mattn/emmet-vim'
"syntastic
NeoBundle 'scrooloose/syntastic'
"endwise
NeoBundle 'tpope/vim-endwise'
"rsense
NeoBundle 'marcus/rsense'
"vim-tags
NeoBundle 'szw/vim-tags'
"AutoComplPop
NeoBundle 'vim-scripts/AutoComplPop'
"html5
NeoBundle 'othree/html5.vim'
"css3-syntax
NeoBundle 'hail2u/vim-css3-syntax'
"csscolor
NeoBundle 'skammer/vim-css-color'
"markdown
NeoBundle 'plasticboy/vim-markdown'
"previm
NeoBundle 'kannokanno/previm'
"open-browser
NeoBundle 'tyru/open-browser.vim'
"neosnipet
if has('lua') && (( v:version == 703 && has('patch885')) || (v:version>= 704))
  NeoBundle 'shougo/neocomplete'
else
  NeoBundle 'shougo/neocomplcache'
fi
NeoBundle "shougo/neosnippet"
NeoBundle "shougo/neosnippet-snippets"
NeoBundle "honza/vim-snippets"
endif

"未インストールチェック
NeoBundleCheck

call neobundle#end()
filetype plugin indent on



"Neosnippet
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"neocompleta
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

"Emmet
let g:user_emmet_leader_key='<c-e>'
let g:user_emmet_settings = {
    \    'variables': {
    \      'lang': "ja"
    \    },
    \   'indentation': '  '
    \ }

"synrastic
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_highlighting = 1
let g:syntastic_php_php_args = '-l'
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checker = 'jshint'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"AutoComplePop
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4

" Rsense
let g:rsenseHome = '/usr/local/lib/rsense-0.3'
let g:rsenseUseOmniFunc = 1

"markdown
autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
autocmd BufRead,BufNewFile *.md  set filetype=markdown

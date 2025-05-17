call plug#begin()
	Plug 'preservim/nerdtree'
	Plug 'Mofiqul/vscode.nvim'
	Plug 'OmniSharp/omnisharp-vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	"Plug 'dense-analysis/ale'
call plug#end()

filetype on

"=== General Configuration ===
set number
set relativenumber
set shiftwidth=4
set tabstop=4
set nowrap
set modifiable
set wildmenu
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

inoremap <C-s> <Esc>:w!<CR>
nnoremap <C-s> :w!<CR>
inoremap <C-x> <Esc>:wq!<CR>
nnoremap <C-x> :q!<CR>

nnoremap so :source $MYVIMRC<CR>

"=== General Configuration ===!

"=== Colorscheme ===
colorscheme vscode
"=== Colorscheme ===!


"=== NERD Tree ===
autocmd VimEnter * NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
"=== NERD Tree ===!

"=== COC autocompletion ===
" Use tab for trigger completion and navigate to the next complete item
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ?
      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Confirm selection with Enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Function to check if backspace is pressed
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <C-space> to manually trigger completion
inoremap <silent><expr> <C-Space> coc#refresh()

" Use K to show documentation
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" Go to definition
nmap <silent> gd <Plug>(coc-definition)
" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

"=== COC autocompletion ===!










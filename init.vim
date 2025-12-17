call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'Mofiqul/vscode.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'romgrk/barbar.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

  " Plugin untuk LSP bawaan Neovim
  Plug 'neovim/nvim-lspconfig'
  Plug 'Hoffs/omnisharp-extended-lsp.nvim'
  Plug 'nvim-lualine/lualine.nvim'

  " Untuk autocompletion
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'rafamadriz/friendly-snippets'  " Add snippets collection

  " TypeScript/JavaScript specific
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

  Plug 'j-hui/fidget.nvim'
  Plug 'numToStr/Comment.nvim'
  Plug 'MisanthropicBit/winmove.nvim'

  " Treesitter for better syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " git
  " Inline git signs
  Plug 'lewis6991/gitsigns.nvim'      
  " Git commands
  Plug 'tpope/vim-fugitive'           
  " Diff views
  Plug 'sindrets/diffview.nvim'       
  " Conflict resolution
  Plug 'akinsho/git-conflict.nvim'    

call plug#end()

filetype on

"=== General Configuration ===
let mapleader=" "
set number
set relativenumber
set shiftwidth=2
set tabstop=2
set expandtab
set nowrap
set modifiable
set wildmenu
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

nnoremap so :source $MYVIMRC<CR>

"=== Colorscheme ===
colorscheme vscode

"=== NERD Tree ===
autocmd VimEnter * NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

let g:NERDTreeIgnore = ['\.git$', '\.pyc$', '__pycache__'] "ignored folders/files

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-h> :let g:NERDTreeShowHidden=1 \| NERDTreeRefreshRoot<CR>
nnoremap <C-j> :NERDTreeRefreshRoot<CR>

"=== Barbar ===
lua require('nvim-web-devicons').setup { default = true; }

"=== config lua ===
lua require('config').setup()

" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>

" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>

" Goto buffer in position...
nnoremap <silent>    <leader>w1 <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <leader>w2 <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <leader>w3 <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <leader>w4 <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <leader>w5 <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <leader>w6 <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <leader>w7 <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <leader>w8 <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <leader>w9 <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <leader>w0 <Cmd>BufferLast<CR>

" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>

" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>
" Restore buffer
nnoremap <silent>    <A-r> <Cmd>BufferRestore<CR>

" Magic buffer-picking mode
nnoremap <silent> <C-p>    <Cmd>BufferPick<CR>
nnoremap <silent> <C-s-p>  <Cmd>BufferPickDelete<CR>

" Sort automatically by...
nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
nnoremap <silent> <Space>bn <Cmd>BufferOrderByName<CR>
nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>

"=== Telescope ===
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"=== Additional Keymaps ===
" Quick navigation
nnoremap <leader>gs :LspStop<CR>
nnoremap <leader>gr :LspRestart<CR>


" Quick file operations
nnoremap <silent> <leader>fs :w!<CR>
nnoremap <silent> <leader>fw :wq!<CR>
nnoremap <silent> <leader>fq :q<CR>

" Vertical splits
nnoremap <leader>sr :set splitright<CR>:vsplit<CR>  
nnoremap <leader>sl :set nosplitright<CR>:vsplit<CR> 

" Horizontal splits
nnoremap <leader>sd :set splitbelow<CR>:split<CR>  
nnoremap <leader>su :set nosplitbelow<CR>:split<CR>

" Navigate splits
nnoremap <leader>hh <C-w>h
nnoremap <leader>ll <C-w>l
nnoremap <leader>kk <C-w>k
nnoremap <leader>jj <C-w>j

" Manage splits
" Increase width
nnoremap <leader><Right> <C-w>>
" Decrease width
nnoremap <leader><Left> <C-w><
" Increase height
nnoremap <leader><Up> <C-w>+
" Decrease height
nnoremap <leader><Down> <C-w>-
" Equalize windows
nnoremap <leader>= <C-w>=


nnoremap <leader>tt :terminal<CR>
nnoremap <leader>th :set splitbelow<CR>:split<CR>:terminal<CR>
nnoremap <leader>tv :set splitright<CR>:vsplit<CR>:terminal<CR>

" Terminal mode navigation (MOST IMPORTANT!)

" Close terminal from terminal mode
tnoremap <leader>q <C-\><C-n><CR>
tnoremap <leader>qc <C-\><C-n>:close<CR>
" Close terminal from normal mode
nnoremap <leader>qc :close<CR>










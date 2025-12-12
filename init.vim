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

  Plug 'j-hui/fidget.nvim'
        Plug 'numToStr/Comment.nvim'

  " Treesitter for better syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

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

" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>

" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>

" Goto buffer in position...
nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>

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

"=== Nvim LSP ===
lua << EOF

vim.lsp.semantic_tokens.enable = true

require("fidget").setup {}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Setup Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c', 'cpp', 'python', 'rust', 'lua', 'vim', 'vimdoc',
    'javascript', 'typescript', 'html', 'css', 'json',
    'markdown', 'bash'
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- Setup luasnip with friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

local lspconfig = require('lspconfig')

-- Setup diagnostics globally
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Autocompletion with improved settings
local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),  -- Ctrl+Space for completion
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Show source name
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        nvim_lua = "[Lua]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }

  if client.name == "omnisharp" then
    vim.keymap.set('n', 'gd', require('omnisharp_extended').lsp_definition, opts)
  else
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)  -- Go to definition
  end

  vim.keymap.set('n', 'fr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>fn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

  -- Formating
  vim.keymap.set('n', '<leader>fa', function()
    vim.lsp.buf.format({ async = true })
  end, { noremap = true, silent = true, buffer = bufnr})
end

-- Omnisharp setup
lspconfig.omnisharp.setup {
  cmd = { 
    os.getenv("HOME") .. "/.local/bin/omnisharp/run", 
    "--languageserver", 
    "--hostPID", 
    tostring(vim.fn.getpid())
  },
  capabilities = capabilities,
  on_attach = on_attach,

  -- Critical for Web API projects
  enable_editorconfig_support = true,
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,

  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },

  -- Web-specific settings
  settings = {
    FormattingOptions = {
      OrganizeImports = true,
      EnableEditorConfigSupport = true,
    },
    MsBuild = {
      LoadProjectsOnDemand = false,
      UseLegacySdkResolver = false,
      MSBuildExtensionsPath = "",
      VisualStudioVersion = "17.0",
      EnablePackageAutoRestore = true,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      EnableDecompilationSupport = true,
      AnalyzeOpenDocumentsOnly = false,
      InlayHintsOptions = {
        EnableForParameters = true,
        EnableForIndexerParameters = true,
        EnableForLiteralParameters = true,
        EnableForObjectCreationParameters = true,
        EnableForOtherParameters = true,
        EnableForTypes = true,
      },
    },
    Sdk = {
      IncludePrereleases = true,
      AllowPrereleaseVersions = true,
    },
    EnablePackageRestore = true,
    AutoStart = true,
    ProjectLoadTimeout = 90,
    MaxProjectResults = 250,
    UseEditorFormattingOptions = true,
  }
}

-- Rust analyzer setup
lspconfig.rust_analyzer.setup {
  cmd = { "rust-analyzer" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = true,
      },
    },
  },
}

-- Clangd setup for C/C++
lspconfig.clangd.setup {
  cmd = { "clangd", "--background-index" },
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  settings = {
    clangd = {
      clangTidy = true,
    }
  }
}

-- Pyright setup for Python
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}

-- Autoformat on save for ALL languages including Python and Rust
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.cpp", "*.hpp", "*.c", "*.h", "*.py", "*.rs", "*.cs" },
  callback = function(args)
    vim.lsp.buf.format({ async = false, bufnr = args.buf })
  end,
})

-- Setup Comment plugin with Ctrl+/ (which is Ctrl+_ in terminal)
require('Comment').setup()

-- Comment keybindings - Ctrl+/ (shows as Ctrl+_ in terminal)
vim.keymap.set('n', '<C-_>', function()
  require('Comment.api').toggle.linewise.current()
end, { noremap = true, silent = true })

vim.keymap.set('v', '<C-_>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { noremap = true, silent = true })

-- Diagnostics navigation
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap=true, silent=true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap=true, silent=true })
vim.keymap.set('n', '<leader>e', function()
  local opts = { focusable = false, border = "rounded" }
  vim.diagnostic.open_float(nil, opts)
end, { noremap=true, silent=true })

-- Additional useful keymaps
-- Find references
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap=true, silent=true })
-- Show line diagnostics
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap=true, silent=true })
-- Go to implementation
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap=true, silent=true })
-- Show signature help
vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { noremap=true, silent=true })

print("LSP configuration loaded successfully!")

EOF
"=== Nvim LSP ===!

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
inoremap <leader>fs <Esc>:w!<CR>
inoremap <leader>fw <Esc>:wq!<CR>

nnoremap <leader>fs :w<CR>
nnoremap <leader>fq :q<CR>
nnoremap <leader>fw :wq<CR>





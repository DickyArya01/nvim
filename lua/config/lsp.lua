-- LSP configuration module
local M = {}

function M.setup()
  print("Setting up LSP...")
  
  -- Use prettier directly via LSP if available
  local prettier_ok, prettier = pcall(require, 'prettier')
  if prettier_ok then
    prettier.setup({
      bin = 'prettier',
      filetypes = {
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "scss",
        "less"
      },
    })
    print("✓ Prettier setup complete")
  end

  -- Load LSP config with error handling
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    print("LSPConfig not available")
    return
  end

  -- Load cmp capabilities with error handling
  local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local capabilities = {}
  if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    print("CMP-NVIM-LSP capabilities loaded")
  else
    print("CMP-NVIM-LSP not available")
  end

  -- Setup diagnostics globally
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- Common on_attach function
  local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- TypeScript-specific: organize imports on save
    if client.name == "ts_ls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
          })
        end,
      })
      
      -- Additional TypeScript shortcuts
      vim.keymap.set('n', '<leader>oi', function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end, { noremap = true, silent = true, buffer = bufnr, desc = "Organize imports" })
    end

    -- Go to definition (with omnisharp special handling)
    if client.name == "omnisharp" then
      vim.keymap.set('n', 'gd', require('omnisharp_extended').lsp_definition, opts)
    else
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end

    -- For web development specific shortcuts
    if client.name == "ts_sl" or client.name == "html" or client.name == "cssls" then
      vim.keymap.set('n', '<leader>dc', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', '<leader>ii', vim.lsp.buf.implementation, opts)
    end

    -- Common LSP keymaps
    vim.keymap.set('n', 'fr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>fn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Formatting
    vim.keymap.set('n', '<leader>fa', function()
      vim.lsp.buf.format({ async = true })
    end, { noremap = true, silent = true, buffer = bufnr})
  end

  -- Formatting helper functions
  local function safe_format()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    
    if #clients > 0 then
      local success, err = pcall(function()
        vim.lsp.buf.format({ async = false })
      end)

      if not success then
        print("Formatting is not available for this type of file")
      end
    else
      print("No LSP client attached - skipping formatting")
    end
  end

  local function safe_format_and_save()
    safe_format()
    vim.cmd('w!')
  end

  local function safe_format_and_quit()
    safe_format()
    vim.cmd('wq!')
  end

  _G.SafeFormatAndSave = safe_format_and_save
  _G.SafeFormatAndQuit = safe_format_and_quit

  -- HTML LSP
  lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'html', 'blade', 'php' },
  })

  -- CSS LSP
  lspconfig.cssls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue',
    },
    root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
    init_options = {
      preferences = {
        includeCompletionsForImportStatements = true,
        includeCompletionsForModuleExports = true,
        includeAutomaticOptionalChainCompletions = true,
      },
    },
    settings = {
      typescript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
    },
  })

  -- PHP LSP - Comment out for now to avoid errors
  -- local phpactor_ok, _ = pcall(require, 'phpactor')
  -- if phpactor_ok then
  --   require('phpactor').setup({
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --   })
  --   print("✓ PHP Actor setup complete")
  -- else
  --   print("✗ PHP Actor not available")
  -- end

  -- Omnisharp setup
  lspconfig.omnisharp.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
  })

  -- Rust analyzer setup
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- Clangd setup
  lspconfig.clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "c", "cpp", "objc", "objcpp" },
  })

  -- Pyright setup
  lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- Autoformat on save for various languages
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { 
      "*.cpp", "*.hpp", "*.c", "*.h", 
      "*.js", "*.ts", "*.jsx", "*.tsx", 
      "*.json", "*.html", "*.css", "*.scss", 
      "*.lua", "*.py", "*.rs", "*.cs"
    },
    callback = function(args)
      vim.lsp.buf.format({ async = false, bufnr = args.buf })
    end,
  })

  -- Setup Comment plugin
  local comment_ok, comment = pcall(require, 'Comment')
  if comment_ok then
    comment.setup()
    
    -- Comment keybindings
    vim.keymap.set('n', '<C-_>', function()
      require('Comment.api').toggle.linewise.current()
    end, { noremap = true, silent = true })

    vim.keymap.set('v', '<C-_>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", 
      { noremap = true, silent = true })
    
    print("Comment setup complete")
  else
    print("Comment not available")
  end

  -- Diagnostics navigation
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap=true, silent=true })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap=true, silent=true })
  vim.keymap.set('n', '<leader>e', function()
    local opts = { focusable = false, border = "rounded" }
    vim.diagnostic.open_float(nil, opts)
  end, { noremap=true, silent=true })

  -- Additional useful keymaps
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap=true, silent=true })
  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap=true, silent=true })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap=true, silent=true })
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { noremap=true, silent=true })

  print("LSP configuration loaded successfully!")
end

return M

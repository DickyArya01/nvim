-- LSP configuration module
local M = {}

function M.setup()
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

    if client.name == "omnisharp" then
      vim.keymap.set('n', 'gd', require('omnisharp_extended').lsp_definition, opts)
    else
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end

    vim.keymap.set('n', 'fr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>fn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Formating
    vim.keymap.set('n', '<leader>fa', function()
      vim.lsp.buf.format({ async = true })
    end, { noremap = true, silent = true, buffer = bufnr})
    
    -- For web development specific shortcuts
    if client.name == "tsserver" or client.name == "html" or client.name == "cssls" then
      vim.keymap.set('n', '<leader>dc', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', '<leader>ii', vim.lsp.buf.implementation, opts)
    end
  end

  -- HTML LSP
  lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'html', 'blade', 'php' },
    settings = {
      html = {
        suggest = {
          html5 = true,
        },
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = 'auto',
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  }

  -- CSS LSP
  lspconfig.cssls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      scss = {
        validate = true,
      },
      less = {
        validate = true,
      },
    },
  }

  -- JavaScript/TypeScript LSP
  lspconfig.tsserver.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    init_options = {
      preferences = {
        includeCompletionsForImportStatements = true,
        includeCompletionsForModuleExports = true,
        includeAutomaticOptionalChainCompletions = true,
      },
    },
    settings = {
      javascript = {
        format = {
          semicolons = 'insert',
        },
        suggest = {
          includeCompletionsWithInsertText = true,
        },
      },
      typescript = {
        format = {
          semicolons = 'insert',
        },
        suggest = {
          includeCompletionsWithInsertText = true,
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
    },
  }

  -- PHP LSP - Using PHP Actor for better PHP support
  require('phpactor').setup({
    on_attach = on_attach,
    capabilities = capabilities,
    install = {
      path = vim.fn.stdpath("data") .. "/phpactor",
      branch = "master",
      bin = vim.fn.stdpath("data") .. "/phpactor/bin/phpactor",
    },
    lspconfig = {
      enabled = true,
      init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
      },
    },
  })

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
    
    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    },

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

  -- Clangd setup
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

  -- Pyright setup
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

  -- Autoformat on save for various languages
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.cpp", "*.hpp", "*.c", "*.h", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html", "*.css", "*.scss", "*.php" },
    callback = function(args)
      vim.lsp.buf.format({ async = false, bufnr = args.buf })
    end,
  })

  -- Setup Comment plugin
  require('Comment').setup()

  -- Comment keybindings
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
end

return M

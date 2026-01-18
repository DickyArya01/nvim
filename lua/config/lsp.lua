--- LSP configuration module dengan Mason
local M = {}

function M.setup()
  print(" ⴵ Setting up LSP with Mason...")

  -- Setup Mason (LSP installer manager)
  local mason_ok, mason = pcall(require, 'mason')
  if not mason_ok then
    print("   ✗ Mason not available")
    return
  end

  local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
  if not mason_lspconfig_ok then
    print("   ✗ mason-lspconfig not available")
    return
  end

  local luasnip_ok, luasnip = pcall(require, 'luasnip')
  if not luasnip_ok then
    print("    ✗ luasnip not available")
    return
  end

  local fluttertools_ok, fluttertools = pcall(require, 'flutter-tools')
  if fluttertools_ok then
    print("    ✗ flutter-tools not available")
  end

  -- Setup Mason
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  mason_lspconfig.setup({
    ensure_installed = {
      "lua_ls",        -- Lua
      "luau_lsp",      -- Luau
      "html",          -- HTML
      "cssls",         -- CSS
      "pyright",       -- Python
      "rust_analyzer", -- Rust
      "clangd",        -- C/C++
      "omnisharp",     -- C#
      "bashls",        -- Bash
      "jsonls",        -- JSON
    },
    automatic_installation = true,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "vim", "help", "qf", "markdown" },
    callback = function(args)
      -- Nonaktifkan LSP untuk filetype ini
      vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = args.buf }))
    end,
  })

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
    print("   • Prettier setup complete")
  end

  -- Load cmp capabilities with error handling
  local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local capabilities = {}
  if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    print("   • CMP-NVIM-LSP capabilities loaded")
  else
    print("   • CMP-NVIM-LSP not available")
    capabilities = vim.lsp.protocol.make_client_capabilities()
  end

  -- Setup diagnostics globally (CARA BARU Neovim 0.10+)
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      spacing = 4,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Common on_attach function
  local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Common LSP keymaps
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    vim.keymap.set('n', 'fr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>fn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Formatting
    vim.keymap.set('n', '<leader>fa', function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Document symbols
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)

    -- Additional useful keymaps
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)

    -- Diagnostics navigation
    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    vim.keymap.set('n', '<leader>e', function()
      vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
    end, opts)

    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
        luasnip.unlink_current()
        print("Unlink snippet and escape")
      else
        print("No snippet to unlink .. Escaping")
      end

      return '<Esc>'
    end, { noremap = true, expr = true })

    vim.keymap.set('n', '<C-l>', function()
      if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
        luasnip.unlink_current()
        print("Unlink snippet")
      else
        print("No snippet to unlink")
      end

      return '<Esc>'
    end, { noremap = true, expr = true })
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
        print("Error formatting" .. tostring(err))
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

  -- Definisikan konfigurasi untuk setiap LSP server
  local lsp_configs = {
    -- Lua LSP
    lua_ls = {
      name = "lua_ls",
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      settings = {
        Lua = {
          runtime = {
            version = 'Lua 5.4',
          },
          diagnostics = {
            globals = { 'vim' }
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false
          },
          telemetry = {
            enable = false
          }
        }
      }
    },

    -- HTML LSP
    html = {
      name = "html",
      cmd = { "vscode-html-language-server", "--stdio" },
      filetypes = { "html" },
      init_options = {
        provideFormatter = true
      }
    },

    -- CSS LSP
    cssls = {
      name = "cssls",
      cmd = { "vscode-css-language-server", "--stdio" },
      filetypes = { "css", "scss", "less" },
      settings = {
        css = {
          validate = true
        },
        scss = {
          validate = true
        },
        less = {
          validate = true
        }
      }
    },

    -- Rust analyzer
    rust_analyzer = {
      name = "rust_analyzer",
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      root_dir = function(_)
        local root_files = {
          "Cargo.toml",
          "rust-project.json",
          ".git"
        }
        return vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1])
      end,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--", "-W", "clippy::pedantic" }
          },
          standalone = true,
          cargo = {
            loadOutDirsFromCheck = true,
            autoreload = true
          },
          diagnostics = {
            disabled = { "unresolved-import" }
          },
          workspace = {
            symbol = {
              search = {
                kind = "all_symbols"
              }
            }
          }
        }
      }
    },

    -- Python (pyright)
    pyright = {
      name = "pyright",
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true
          }
        }
      }
    },

    -- C/C++ (clangd)
    clangd = {
      name = "clangd",
      cmd = { "clangd" },
      filetypes = { "c", "cpp", "objc", "objcpp" },
      capabilities = vim.tbl_extend("keep", capabilities, {
        offsetEncoding = { "utf-16" }
      })
    },

    -- C# (omnisharp)
    omnisharp = {
      name = "omnisharp",
      cmd = { "omnisharp", "--languageserver" },
      filetypes = { "cs" },
      enable_editorconfig_support = true,
      enable_roslyn_analyzers = true,
      organize_imports_on_format = true,
      enable_import_completion = true,
    },

    -- Bash LSP
    bashls = {
      name = "bashls",
      cmd = { "bash-language-server", "start" },
      filetypes = { "sh", "bash" },
      settings = {}
    },

    -- JSON LSP
    jsonls = {
      name = "jsonls",
      cmd = { "vscode-json-language-server", "--stdio" },
      filetypes = { "json", "jsonc" },
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true }
        }
      }
    },
  }

  -- Map filetype ke server LSP
  local filetype_to_server = {
    lua = "lua_ls",
    luau = "luau_lsp",
    html = "html",
    css = "cssls",
    scss = "cssls",
    less = "cssls",
    rust = "rust_analyzer",
    python = "pyright",
    c = "clangd",
    cpp = "clangd",
    objc = "clangd",
    objcpp = "clangd",
    cs = "omnisharp",
    sh = "bashls",
    bash = "bashls",
    zsh = "bashls",
    json = "jsonls",
    jsonc = "jsonls",
  }

  fluttertools.setup {
    ui = {
      border = "rounded",
      notification_style = 'native'
    },
    decorations = {
      statusline = {
        app_version = false,
        device = false,
        project_config = false,
      }
    },
    debugger = {
      enabled = false,
      exception_breakpoints = {},
      evaluate_to_string_in_debug_views = true,
    },
    flutter_path = os.getenv('HOME') .. "/develop/flutter/bin", -- <-- this takes priority over the lookup
    -- flutter_lookup_cmd = "dirname ${which flutter}", -- example "dirname $(which flutter)" or "asdf where flutter"
    root_patterns = { ".git", "pubspec.yaml" },                 -- patterns to find the root of your flutter project
    fvm = true,                                                 -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
    default_run_args = nil,                                     -- Default options for run command (i.e `{ flutter = "--no-version-check" }`). Configured separately for `dart run` and `flutter run`.
    widget_guides = {
      enabled = true,
    },
    closing_tags = {
      highlight = "Comment", -- highlight for the closing tag
      prefix = "-- ",        -- character to use for close tag e.g. > Widget
      priority = 10,         -- priority of virtual text in current line
      -- consider to configure this when there is a possibility of multiple virtual text items in one line
      -- see `priority` option in |:help nvim_buf_set_extmark| for more info
      enabled = true -- set to false to disable
    },
    dev_log = {
      enabled = true,
      filter = nil, -- optional callback to filter the log
      -- takes a log_line as string argument; returns a boolean or nil;
      -- the log_line is only added to the output if the function returns true
      notify_errors = false, -- if there is an error whilst running then notify the user
      open_cmd = "15split",  -- command to use to open the log buffer
      focus_on_open = true,  -- focus on the newly opened log window
    },
    dev_tools = {
      autostart = false,         -- autostart devtools server if not detected
      auto_open_browser = false, -- Automatically opens devtools in the browser
    },
    outline = {
      open_cmd = "30vnew", -- command to use to open the outline buffer
      auto_open = false    -- if true this will open the outline automatically when it is first populated
    },
    lsp = {
      color = { -- show the derived colours for dart variables
        enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
        background = false, -- highlight the background
        background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
        foreground = false, -- highlight the foreground
        virtual_text = true, -- show the highlight using virtual text
        virtual_text_str = "■", -- the virtual text character to highlight
      },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        showTodos = true,
        completeFunctionCalls = true,
        analysisExcludedFolders = {
          '**/build/**',
          '**/dart_tool/**',
          '**/.pub-cache',
          '**/node_modules/**',
        },
        renameFilesWithClasses = "prompt", -- "always"
        enableSnippets = true,
        updateImportsOnRename = true,      -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
      }
    }
  }


  -- Setup autocmd untuk start LSP berdasarkan filetype
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local bufnr = args.buf
      local server_name = filetype_to_server[ft]

      if server_name and lsp_configs[server_name] then
        local config = lsp_configs[server_name]

        -- Gabungkan dengan config default
        local final_config = vim.tbl_deep_extend("force", {
          bufnr = bufnr,
          capabilities = capabilities,
          on_attach = on_attach,
        }, config)

        -- Start LSP server
        vim.lsp.start(final_config)
        -- print("Started LSP: " .. server_name .. " for " .. ft)
      end
    end,
  })

  -- Setup null-ls (untuk linters dan formatters) jika ada
  local null_ls_ok, null_ls = pcall(require, 'null-ls')
  if null_ls_ok then
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    null_ls.setup({
      sources = {
        -- Formatting
        formatting.stylua,         -- Lua
        formatting.prettier.with({ -- JavaScript, TypeScript, CSS, etc
          extra_args = { "--single-quote", "--jsx-single-quote" }
        }),
        formatting.black,   -- Python
        formatting.isort,   -- Python import sorting
        formatting.rustfmt, -- Rust
        formatting.shfmt,   -- Shell script

        -- Diagnostics
        diagnostics.eslint_d,   -- JavaScript/TypeScript
        diagnostics.flake8,     -- Python
        diagnostics.shellcheck, -- Shell script

        -- Code Actions
        code_actions.eslint_d, -- JavaScript/TypeScript
        code_actions.gitsigns, -- Git
      },
      on_attach = on_attach,
    })
    print("   • Null-ls setup complete")
  end

  -- Autoformat on save for various languages
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {
      "*.cpp", "*.hpp", "*.c", "*.h",
      "*.js", "*.ts", "*.jsx", "*.tsx",
      "*.json", "*.html", "*.css", "*.scss",
      "*.lua", "*.py", "*.rs", "*.cs",
      "*.sh", "*.bash", "*.dart",
      "*.luau" },
    callback = function(args)
      -- Skip jika filetype adalah vim
      local filetype = vim.bo[args.buf].filetype
      if filetype == "vim" then
        return
      end

      if filetype == "luau" then
        local filepath = vim.fn.expand('%:p')
        vim.cmd('w!')

        local cmd = vim.cmd('!stylua ' .. vim.fn.shellescape(filepath))
        vim.fn.system(cmd)

        vim.cmd('e!')
        return
      end

      vim.lsp.buf.format({ async = false, bufnr = args.buf })
    end,
  })

  -- Setup Comment plugin
  local comment_ok, comment = pcall(require, 'Comment')
  if comment_ok then
    comment.setup()

    -- Comment keybindings
    vim.keymap.set('n', '<C-c>', function()
      require('Comment.api').toggle.linewise.current()
    end, { noremap = true, silent = true })

    vim.keymap.set('v', '<C-c>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      { noremap = true, silent = true })

    print("   • Comment setup complete")
  else
    print("   • Comment not available")
  end

  -- Mason commands
  vim.keymap.set('n', '<leader>m', '<cmd>Mason<CR>', { desc = 'Open Mason' })
  vim.keymap.set('n', '<leader>mi', '<cmd>MasonInstall<CR>', { desc = 'Mason Install' })
  vim.keymap.set('n', '<leader>mu', '<cmd>MasonUpdate<CR>', { desc = 'Mason Update' })

  print("   • Mason setup complete")
  print(" ✔ LSP configuration loaded successfully (using native vim.lsp.start)")
end

return M

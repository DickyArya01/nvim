-- Autocompletion configuration
local M = {}

function M.setup()
  print("Setting up autocompletion...")
  
  -- Load luasnip with error handling
  local luasnip_ok, luasnip = pcall(require, 'luasnip')
  if not luasnip_ok then
    print("Luasnip not available")
    return
  end
  
  -- Load vscode snippets
  local loaders_ok = pcall(require('luasnip.loaders.from_vscode').lazy_load)
  if not loaders_ok then
    print("Could not load vscode snippets")
  end
  
  -- Setup luasnip
  luasnip.config.setup({
    history = true,
    updateevents = "TextChanged,TextChangedI",
  })
  
  -- Load cmp with error handling
  local cmp_ok, cmp = pcall(require, 'cmp')
  if not cmp_ok then
    print("CMP not available")
    return
  end
  
  -- Setup cmp
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      -- ['<Tab>'] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   elseif luasnip.expand_or_jumpable() then
      --     luasnip.expand_or_jump()
      --   else
      --     fallback()
      --   end
      -- end, { 'i', 's' }),
      -- ['<S-Tab>'] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif luasnip.jumpable(-1) then
      --     luasnip.jump(-1)
      --   else
      --     fallback()
      --   end
      -- end, { 'i', 's' }),
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
        })[entry.source.name] or "[" .. entry.source.name .. "]"
        return vim_item
      end,
    },
  })
  
  -- HTML snippets helper function
  _G.create_html_snippets = function()
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node
    
    luasnip.add_snippets("html", {
      s("html5", {
        t({"<!DOCTYPE html>", "<html lang=\"en\">", "<head>", "  <meta charset=\"UTF-8\">", 
           "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">", 
           "  <title>"}), i(1, "Document"), t({"</title>", "</head>", "<body>", "  "}), i(2), t({"", "</body>", "</html>"})
      }),
      s("div", {
        t("<div"), i(1), t(">"), i(2), t("</div>")
      }),
      s("php", {
        t({"<?php", ""}), i(1), t({"", "?>"})
      }),
    })
  end
  
  -- Create custom snippets after a delay
  vim.defer_fn(function()
    _G.create_html_snippets()
    print("Custom HTML snippets created")
  end, 1000)
  
  print("Autocompletion setup complete")
end

return M

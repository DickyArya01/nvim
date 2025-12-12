-- Autocompletion configuration
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
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

-- HTML snippets helper function
_G.create_html_snippets = function()
  local ls = require('luasnip')
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  
  ls.add_snippets("html", {
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

-- Create custom snippets
vim.defer_fn(function()
  _G.create_html_snippets()
end, 1000)

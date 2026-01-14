-- UI configuration

local M = {}

local plugins_loaded = {
  LUALINE = false,
  WINMOVE = false,
  FIDGET = false,
  TRANSPARENT = false,
}

local total_plugins = 4

function M.check_plugins_status(v)
  local current_count = 0

  for _, loaded in pairs(v) do
    if loaded then current_count = current_count + 1 end
  end

  if current_count == total_plugins then
    print(" ✔ UI Setup Complete")
  elseif current_count > 0 then
    print(" ⚠︎ UI Setup Partial Complete")
  else
    print(" ⊘  UI Setup Failed")
  end
end

function M.setup()
  print(" ⴵ Setting up UI...")

  vim.lsp.semantic_tokens.enable = true

  local winmove_ok, winmove = pcall(require, 'winmove')

  if winmove_ok then
    vim.keymap.set('n', '<leader>wm', function()
      winmove.start_mode('move')
    end)

    plugins_loaded.WINMOVE = true

    print("   • winmove setup complete")
  else
    print("   • winmove is not available")
  end

  local fidget_ok, figet = pcall(require, "fidget")
  if fidget_ok then
    figet.setup({})

    plugins_loaded.FIDGET = true

    print("   • Fidget setup complete")
  else
    print("   • Fidget is not available")
  end

  local lualine_ok, lualine = pcall(require, 'lualine')
  if lualine_ok then
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { -- Line 18 - fixed here
          statusline = {},
          winbar = {},
        }, -- This was missing!
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        }
      }, -- Closing options table
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    })

    plugins_loaded.LUALINE = true

    print("   • lualine setup complete")
  else
    print("   • lualine is not available")
  end

  local transparent_ok, transparent = pcall(require, 'transparent')

  if transparent_ok then
    transparent.setup({
      groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLineNr', 'EndOfBuffer',
      },
      -- table: additional groups that should be cleared
      extra_groups = {
        'BufferLineTabClose',
        'BufferlineBufferSelected',
        'BufferLineFill',
        'BufferLineBackground',
        'BufferLineSeparator',
        'BufferLineIndicatorSelected',
      },
      -- table: groups you don't want to clear
      exclude_groups = {},
      -- function: code to be executed after highlight groups are cleared
      -- Also the user event "TransparentClear" will be triggered
      on_clear = function() end,
    })


    vim.keymap.set('n', '<leader>ut', ':TransparentToggle<CR>')

    plugins_loaded.TRANSPARENT = true

    print("   • transparent setup complete")
  else
    print("   • transparent not available")
  end

  M.check_plugins_status(plugins_loaded)
end

return M

-- UI configuration

local M = {}

function M.setup()
  print(" ⴵ Setting up UI...")

  vim.lsp.semantic_tokens.enable = true

  local totalConfigCount = 2;
  local completeConfig = 0;

  local winmove_ok, winmove = pcall(require, 'winmove')

  if winmove_ok then

    vim.keymap.set('n', '<leader>wm', function()
      winmove.start_mode('move')
    end)
    
    print("   • winmove setup complete")
  else
    print("   • winmove is not available")
  end

  local fidget_ok, figet = pcall(require, "fidget")
  if fidget_ok then 
    figet.setup({})

    completeConfig = completeConfig + 1

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
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {  -- Line 18 - fixed here
          statusline = {},
          winbar = {},
        },  -- This was missing!
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        }
      },  -- Closing options table
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
    })
    completeConfig = completeConfig + 1
    print("   • lualine setup complete")
  else
    print("   • lualine is not available")
  end

  if completeConfig == 0 then
    print(" ⊘ UI setup is failed")
  elseif completeConfig > 0 and completeConfig < totalConfigCount then
    print(" ⚠︎ UI setup partially success")
  else  
    print(" ✔ UI setup complete")
  end

end

return M




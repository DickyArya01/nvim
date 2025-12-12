-- Main configuration file that loads all modules
local M = {}

local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    print("Warning: Failed to load module: " .. module .. " - " .. result)
    return nil
  end
  return result
end

function M.setup()
  print("Loading config modules...")

  -- Try to load each module
  safe_require('config.ui')
  safe_require('config.treesitter')
  safe_require('config.cmp')
  safe_require('config.lsp')

  print("Config modules loaded successfully!")
end

return M

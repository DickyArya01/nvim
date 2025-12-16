-- Init lua
local M = {}

function M.setup()
  print("ⴵ Loading config module...")

  -- Load each module directly
  require('config.ui').setup()
  require('config.treesitter').setup()
  require('config.cmp').setup()
  require('config.lsp').setup()
  require('config.manual').setup()

  print("✔ Config modules loaded successfully")
end

return M


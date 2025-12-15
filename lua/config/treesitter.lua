-- Treesitter configuration

local M = {}

function M.setup()
  local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter')
  if not treesitter_ok then
    print("nvim-treesitter plugin not installed or loaded")
    return
  end
  
  local configs_ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not configs_ok then
    print("nvim-treesitter.configs module not found")
    return
  end
  
  configs.setup({
    ensure_installed = {
      'c', 'cpp', 'python', 'rust', 'lua', 'vim', 'vimdoc',
      'javascript', 'typescript', 'tsx', 'html', 'css', 'json',
      'php', 'markdown', 'bash'
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  })
  print("Treesitter setup complete")
end

return M


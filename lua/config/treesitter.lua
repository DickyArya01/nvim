-- Treesitter configuration

local M = {}

function M.setup()
  print(" ⴵ Setting up Treesitter...")

  local treesitter_ok, _ = pcall(require, 'nvim-treesitter')
  if not treesitter_ok then
    print("   • nvim-treesitter plugin not installed or loaded")
    print(" ⊘ Treesitter Setup Failed")
    return
  end

  local configs_ok, configs = pcall(require, 'nvim-treesitter.config')
  if not configs_ok then
    print("nvim-treesitter.configs module not found")
    return
  end

  configs.setup({
    install_dir = "",
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
  print(" ✔ Treesitter Setup Complete")
end

return M

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
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
}

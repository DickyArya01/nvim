# Neovim Configuration - User Manual

## 📋 Overview
This Neovim configuration is optimized for modern software development with comprehensive language support, smart autocompletion, and an efficient workflow. It features a clean VS Code-like interface with powerful plugins for navigation, editing, and language support.

## 📑 Table of Contents
1. [✨ Features](#-features)
2. [🚀 Installation Requirements](#-installation-requirements)
3. [🔧 Configuration Installation](#-configuration-installation)
4. [⌨️ Keybindings Reference](#-keybindings-reference)
   - [General Navigation](#general-navigation)
   - [File Explorer (NERDTree)](#file-explorer-nerdtree)
   - [Telescope (Fuzzy Finder)](#telescope-fuzzy-finder)
   - [LSP (Language Server Protocol)](#lsp-language-server-protocol)
   - [Autocompletion](#autocompletion)
   - [Code Commenting](#code-commenting)
   - [Quick Actions](#quick-actions)
   - [Terminal Actions](#terminal-actions)
   - [Split Windows](#split-windows)
   - [Buffer Management](#buffer-management)
5. [🖥️ Supported Languages & Setup](#-supported-languages--setup)
6. [⚙️ Customization](#-customization)
7. [🐛 Troubleshooting](#-troubleshooting)
8. [🎯 Tips & Tricks](#-tips--tricks)
9. [🔄 Updates](#-updates)
10. [📚 Additional Resources](#-additional-resources)

---

## ✨ Features
| Category | Features |
|----------|----------|
| **UI & Theme** | VS Code-inspired color scheme, Clean interface, Status line with lualine |
| **Navigation** | NERDTree file explorer, Telescope fuzzy finder, Buffer tabs with barbar |
| **Code Intelligence** | LSP support for multiple languages, Smart autocompletion, Snippets |
| **Syntax & Formatting** | Treesitter syntax highlighting, Language-specific formatters, Comment toggling |
| **Development** | Terminal integration, Split window management, Project-wide search |
| **Productivity** | Format on save, Quick file operations, Diagnostic navigation |

## 🚀 Installation Requirements

### 1. Prerequisites
```bash
# Install Neovim (>= 0.9.0)
# Install Git
# Install Node.js (for some LSP servers)
# Install .NET SDK (for Omnisharp/C#)
```

### 2. Plugin Manager
This config uses **vim-plug**. Install it first:
```bash
# Unix/Linux
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

### 3. Language Servers
Install required LSP servers:
```bash
# C# - Omnisharp
wget https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-linux-x64.tar.gz
tar -xzf omnisharp-linux-x64.tar.gz -C ~/.local/bin/
mv ~/.local/bin/omnisharp-linux-x64 ~/.local/bin/omnisharp

# Rust
rustup component add rust-analyzer

# C/C++
sudo apt-get install clangd  # or your package manager equivalent

# Python
pip install pyright

# TypeScript/JavaScript
npm install -g typescript typescript-language-server
```

## 🔧 Configuration Installation

1. **Copy the config file:**
```bash
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim
```

2. **Install plugins:**
Open Neovim and run:
```vim
:PlugInstall
```

3. **Install Treesitter parsers:**
```vim
:TSInstall c cpp python rust lua vim vimdoc javascript typescript html css json markdown bash
```

## ⌨️ Keybindings Reference

### General Navigation
| Key | Mode | Action |
|-----|------|--------|
| `<leader>` | - | Space key |
| `so` | Normal | Reload Neovim config |
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to below window |
| `<C-k>` | Normal | Move to above window |
| `<C-l>` | Normal | Move to right window |

### File Explorer (NERDTree)
| Key | Action |
|-----|--------|
| `<leader>n` | Focus NERDTree |
| `<C-n>` | Open NERDTree |
| `<C-t>` | Toggle NERDTree |
| `<C-f>` | Find current file in NERDTree |
| `<C-h>` | Show hidden files |
| `<C-j>` | Refresh NERDTree |

### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep in files |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |

### LSP (Language Server Protocol)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `fr` / `gr` | Find references |
| `K` | Hover information |
| `<leader>fn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>fa` | Format document |
| `gi` | Go to implementation |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Show diagnostics |
| `<leader>d` | Line diagnostics |
| `<leader>k` | Signature help |

### Autocompletion
| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<Tab>` | Next completion item or expand snippet |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Confirm selection |

### Code Commenting
| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+/` | Normal | Toggle line comment |
| `Ctrl+/` | Visual | Toggle block comment |

### Quick Actions
| Key | Action |
|-----|--------|
| `<leader>fs` | Format and save |
| `<leader>fw` | Format and save+quit |
| `<leader>fq` | Quit |
| `<leader>gs` | Stop LSP |
| `<leader>gr` | Restart LSP |

### Terminal Actions
| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Open terminal |
| `<leader>th` | Normal | Open split terminal below |
| `<leader>tv` | Normal | Open split terminal right |
| `<leader>q` | Terminal | Close terminal |
| `<leader>qc` | Normal | Close terminal |

### Split Windows
| Key | Action |
|-----|--------|
| `<leader>sr` | Split vertically (right) |
| `<leader>sl` | Split vertically (left) |
| `<leader>sd` | Split horizontally (below) |
| `<leader>su` | Split horizontally (above) |
| `<leader>=` | Equalize all splits |
| `<leader><Right>` | Increase vertical split width |
| `<leader><Left>` | Decrease vertical split width |
| `<leader><Up>` | Increase horizontal split height |
| `<leader><Down>` | Decrease horizontal split height |

### Buffer Management
| Key | Action |
|-----|--------|
| `<A-,>` | Previous buffer |
| `<A-.>` | Next buffer |
| `<leader>w1` to `<leader>w9` | Go to buffer 1-9 |
| `<leader>w0` | Go to last buffer |
| `<A-p>` | Pin/unpin buffer |
| `<A-c>` | Close buffer |
| `<C-p>` | Buffer pick mode |

## 🖥️ Supported Languages & Setup
| Language | LSP Server | Auto-format | File Types |
|----------|------------|-------------|------------|
| **C# (.NET)** | Omnisharp | Yes | `.cs` |
| **Rust** | rust-analyzer | Yes | `.rs` |
| **C/C++** | clangd | Yes | `.c`, `.cpp`, `.h`, `.hpp` |
| **Python** | pyright | Yes | `.py` |
| **JavaScript/TypeScript** | tsserver | Yes | `.js`, `.jsx`, `.ts`, `.tsx` |
| **Lua** | lua_ls | Yes | `.lua` |
| **HTML/CSS** | html/css LSP | Yes | `.html`, `.css` |
| **Bash/Shell** | bashls | Yes | `.sh`, `.bash` |
| **JSON/YAML** | jsonls/yamlls | Yes | `.json`, `.yaml`, `.yml` |
| **Markdown** | marksman | Yes | `.md`, `.markdown` |

## ⚙️ Customization

### Color Scheme
The config uses `vscode.nvim` theme. Change it by modifying:
```vim
colorscheme vscode
```
Replace `vscode` with any installed colorscheme.

### Tab Settings
Modify these lines to change tab behavior:
```vim
set shiftwidth=2    " Indent size
set tabstop=2       " Tab width
set expandtab       " Use spaces instead of tabs
```

### Adding New LSP Servers
Add new language servers in the Lua section:
```lua
lspconfig.lua_ls.setup {  -- Example for Lua
  capabilities = capabilities,
  on_attach = on_attach,
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Plugins not loading:**
```vim
:PlugStatus  # Check plugin status
:PlugInstall # Reinstall plugins
```

2. **LSP not working:**
   - Check if language server is installed
   - Run `:LspInfo` to check server status
   - Check `:messages` for errors

3. **Autocompletion not showing:**
   - Ensure `<C-Space>` is mapped correctly
   - Check if `nvim-cmp` is installed

4. **Format on save not working:**
   - Verify LSP server supports formatting
   - Check file extension is in auto-format pattern

5. **Terminal not closing:**
   - Use `<leader>qc` in normal mode or `<leader>q` in terminal mode
   - Ensure process has exited before closing

### Debug Commands
```vim
:checkhealth      # Comprehensive health check
:LspLog           # View LSP logs
:TSInstallInfo    # Check Treesitter parsers
:messages         # Show error messages
:LspInfo          # Show LSP server information
```

## 🎯 Tips & Tricks

1. **Quick configuration reload:** Type `so` in Normal mode
2. **Hidden files in NERDTree:** Press `Ctrl+h` to toggle
3. **Buffer management:** Use `Alt+,` and `Alt+.` to navigate quickly
4. **Project-wide search:** Use `<leader>fg` with Telescope
5. **Diagnostics:** Hover over errors with `K` or navigate with `[d`/`]d`
6. **Quick file navigation:** Use `<leader>ff` to find files by name
7. **Code actions:** Use `<leader>ca` for quick fixes and refactoring
8. **Format code:** Use `<leader>fa` to format current buffer

## 🔄 Updates

To update all plugins:
```vim
:PlugUpdate
```

To update Treesitter parsers:
```vim
:TSUpdate
```

## 📚 Additional Resources

- [Neovim documentation](https://neovim.io/doc/)
- [vim-plug GitHub](https://github.com/junegunn/vim-plug)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [ToggleTerm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [NERDTree](https://github.com/preservim/nerdtree)
- [Barbar.nvim](https://github.com/romgrk/barbar.nvim)

---

**Note:** This configuration is optimized for a developer workflow with multiple languages. Adjust keybindings and settings to match your personal preferences.

[Docs](https://github.com/DickyArya01/nvim)

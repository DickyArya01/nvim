# Neovim Configuration - User Manual

## 📋 Overview
This Neovim configuration is optimized for modern software development with comprehensive language support, smart autocompletion, and an efficient workflow. It features a clean VS Code-like interface with powerful plugins for navigation, editing, and language support.

## 📑 Table of Contents
1. [✨ Features](#-features)
2. [🚀 Installation Requirements](#-installation-requirements)
3. [🔧 Configuration Installation](#-configuration-installation)
4. [📒 Manual](#-manual)
   - [Manual System](#manual-system)
   - [File Navigation](#file-navigation)
   - [Code Navigation & LSP](#code-navigation-&-lsp)
   - [Editing & Formatting](#editing-and-formatting)
   - [Window Management](#window-management)
   - [Buffer Management](#buffer-management)
   - [Terminal](#terminal)
   - [Configuration & Utilities](#configuration-utilities)
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

## 📒 Manual

### 📚 Manual System
| Key | Action | Description |
|-----|--------|-------------|
| **`<leader>mm`** | **Open Manual Browser** | Browse all manual files with live preview |
| **`<leader>mn`** | **Create New Manual** | Create new manual file with template |
| **`<leader>me`** | **Edit Manual** | Edit existing manual files |
| **`<Enter>`** (in browser) | **Open Manual** | Open selected manual in vertical split |
| **`<C-e>`** (in browser) | **Edit Manual** | Edit selected manual directly |
| **`<C-j>`** (in preview) | **Scroll Down** | Scroll down in manual preview |
| **`<C-k>`** (in preview) | **Scroll Up** | Scroll up in manual preview |
| **`<Esc>`** / **`q`** | **Close Browser** | Close manual browser |

### 📁 File Navigation
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle NERDTree file explorer |
| `<leader>n` | Focus NERDTree |
| `<C-f>` | Find current file in NERDTree |
| `<C-h>` | Show hidden files in NERDTree |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep in files |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |

### 💻 Code Navigation & LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gr` | Find references |
| `gi` | Go to implementation |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Show diagnostic in float |
| `<leader>ca` | Code actions menu |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format current file |
| `<leader>fa` | Auto-format on save |

### 🔧 Editing & Formatting
| Key | Mode | Action |
|-----|------|--------|
| `<C-c>` (Ctrl+/) | Normal | Toggle line comment |
| `<C-c>` (Ctrl+/) | Visual | Toggle block comment |
| `<leader>fs` | Normal | Format and save |
| `<leader>fw` | Normal | Format and save+quit |
| `<C-Space>` | Insert | Trigger autocompletion |
| `<Tab>` | Insert | Next completion item |
| `<S-Tab>` | Insert | Previous completion item |

### 🪟 Window Management
| Key | Action |
|-----|--------|
| `<leader>hh` / `<C-h>` | Move to left window |
| `<leader>ll` / `<C-l>` | Move to right window |
| `<leader>kk` / `<C-k>` | Move to up window |
| `<leader>jj` / `<C-j>` | Move to down window |
| `<leader>sr` | Vertical split (right) |
| `<leader>sl` | Vertical split (left) |
| `<leader>sd` | Horizontal split (down) |
| `<leader>su` | Horizontal split (up) |
| `<leader>=` | Equalize all windows |
| `<leader><arrow keys>` | Resize windows |
| `<leader>wm` | Move window mode |
| `h/j/k/l` | (move window mode) Move window left/down/up/right |
| `H/J/K/L` | (move window mode) Move window far left/down/up/right |

### 📚 Buffer Management
| Key | Action |
|-----|--------|
| `<A-,>` (Alt+,) | Previous buffer |
| `<A-.>` (Alt+.) | Next buffer |
| `<A-c>` (Alt+c) | Close current buffer |
| `<leader>w1`-`<leader>w9` | Go to buffer 1-9 |
| `<leader>w0` | Go to last buffer |
| `<A-p>` (Alt+p) | Pin/unpin buffer |
| `<C-p>` (Ctrl+p) | Buffer pick mode |

### 🖥️ Terminal
| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Open terminal in new tab |
| `<leader>th` | Normal | Horizontal terminal split |
| `<leader>tv` | Normal | Vertical terminal split |
| `<leader>q` | Terminal | Exit terminal mode |
| `<leader>qc` | Normal | Close terminal window |

### ⚙️ Configuration & Utilities
| Key | Action |
|-----|--------|
| `so` | Reload Neovim configuration |
| `<leader>gs` | Stop LSP server |
| `<leader>gr` | Restart LSP server |
| `<leader>fq` | Quit Neovim |

---

## 🎯 Quick Reference Guide

### Most Used Shortcuts:
1. **`<leader>mm`** - Open manual (learn everything here!)
2. **`<leader>ff`** - Find files quickly
2. **`<leader>fg`** - Find keyword quickly
3. **`gd`** - Go to code definition
4. **`<leader>ca`** - Quick fixes & refactoring
5. **`<C-c>`** - Toggle comments

### Manual Location:
All manuals are stored in `~/.config/nvim/manuals/`
- Press `<leader>mm` to browse
- Press `<leader>mn` to create new
- Press `<leader>me` to edit existing

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

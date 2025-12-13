# Neovim Configuration - User Manual

## 📋 Overview
This Neovim configuration is optimized for modern software development with comprehensive language support, smart autocompletion, and an efficient workflow. It features a clean VS Code-like interface with powerful plugins for navigation, editing, and language support.

## ✨ Features
- 🎨 VS Code-inspired color scheme
- 📁 NERDTree file explorer
- 🧭 Telescope fuzzy finder
- 📊 Barbar buffer tabs
- 🧠 LSP support for multiple languages
- 🤖 Autocompletion with snippets
- 🌳 Treesitter syntax highlighting
- 📝 Comment toggling
- 🎯 Language-specific formatters

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
| `<A-,>` | Normal | Previous buffer (Alt+,) |
| `<A-.>` | Normal | Next buffer (Alt+.) |
| `<A-1>` to `<A-9>` | Normal | Go to buffer 1-9 |
| `<A-0>` | Normal | Go to last buffer |
| `<A-p>` | Normal | Pin/unpin buffer |
| `<A-c>` | Normal | Close buffer |
| `<C-p>` | Normal | Buffer pick mode |

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
| `<leader>sr` | Split Buffer Right |
| `<leader>sl` | Split Buffer Left |


### Terminal Actions
| `<leader>th` | Open split terminal below |
| `<leader>tv` | Open split terminal right |
| `<leader>q` | Close terminal on terminal mode |
| `<leader>qc` | Close terminal on normal mode |

## 🖥️ Supported Languages & Setup

### C# (.NET)
- **Server**: Omnisharp
- **Features**: Full .NET support, Roslyn analyzers, import completion
- **Auto-format**: Yes (on save)
- **File types**: `.cs`

### Rust
- **Server**: rust-analyzer
- **Features**: Full Rust support, diagnostics
- **Auto-format**: Yes (on save)
- **File types**: `.rs`

### C/C++
- **Server**: clangd
- **Features**: Background indexing, clang-tidy
- **Auto-format**: Yes (on save)
- **File types**: `.c`, `.cpp`, `.h`, `.hpp`

### Python
- **Server**: pyright
- **Features**: Type checking, auto imports
- **Auto-format**: Yes (on save)
- **File types**: `.py`

### Other Languages
- Lua, JavaScript, TypeScript, HTML, CSS, JSON, Markdown, Bash
- All have Treesitter highlighting and basic LSP support

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

### Debug Commands
```vim
:checkhealth      # Comprehensive health check
:LspLog           # View LSP logs
:TSInstallInfo    # Check Treesitter parsers
```

## 🎯 Tips & Tricks

1. **Quick configuration reload:** Type `so` in Normal mode
2. **Hidden files in NERDTree:** Press `Ctrl+h` to toggle
3. **Buffer management:** Use `Alt+,` and `Alt+.` to navigate quickly
4. **Project-wide search:** Use `<leader>fg` with Telescope
5. **Diagnostics:** Hover over errors with `K` or navigate with `[d`/`]d`

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

---

**Note:** This configuration is optimized for a developer workflow with multiple languages. Adjust keybindings and settings to match your personal preferences.

[Docs](https://github.com/DickyArya01/nvim)

# nvim

Oke 👍. Berdasarkan `init.vim` yang sudah Anda tulis, saya akan buatkan manual singkat dalam bentuk **Markdown (`.md`)**. Ini semacam dokumentasi agar Anda (atau orang lain) bisa langsung paham bagaimana menggunakan konfigurasi Neovim tersebut.

---

# 📖 Neovim Manual

## ✨ Plugin yang Digunakan

Konfigurasi ini menggunakan [vim-plug](https://github.com/junegunn/vim-plug). Plugin yang dipasang:

* **File Explorer & UI**

  * [`preservim/nerdtree`](https://github.com/preservim/nerdtree) → File explorer.
  * [`nvim-tree/nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) → Icon untuk file.
  * [`romgrk/barbar.nvim`](https://github.com/romgrk/barbar.nvim) → Buffer/tabline modern.
  * [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) → Statusline.

* **Colorscheme**

  * [`Mofiqul/vscode.nvim`](https://github.com/Mofiqul/vscode.nvim) → Tema mirip VSCode.

* **LSP & Autocompletion**

  * [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) → Konfigurasi LSP.
  * [`Hoffs/omnisharp-extended-lsp.nvim`](https://github.com/Hoffs/omnisharp-extended-lsp.nvim) → Tambahan untuk Omnisharp.
  * [`hrsh7th/nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) → Engine autocompletion.
  * [`hrsh7th/cmp-nvim-lsp`](https://github.com/hrsh7th/cmp-nvim-lsp) → Sumber LSP untuk nvim-cmp.
  * [`hrsh7th/cmp-buffer`](https://github.com/hrsh7th/cmp-buffer) → Completion dari buffer.
  * [`hrsh7th/cmp-path`](https://github.com/hrsh7th/cmp-path) → Completion untuk path.
  * [`L3MON4D3/LuaSnip`](https://github.com/L3MON4D3/LuaSnip) → Snippet engine.
  * [`saadparwaiz1/cmp_luasnip`](https://github.com/saadparwaiz1/cmp_luasnip) → Integrasi LuaSnip.

* **Utility**

  * [`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) → Dependency.
  * [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) → Finder & fuzzy search.
  * [`j-hui/fidget.nvim`](https://github.com/j-hui/fidget.nvim) → UI progress untuk LSP.
  * [`numToStr/Comment.nvim`](https://github.com/numToStr/Comment.nvim) → Toggle komentar.

---

## ⚙️ General Configuration

* `number`, `relativenumber` → Tampilkan nomor baris relatif.
* `tabstop=4`, `shiftwidth=4`, `expandtab` → Indentasi default: 4 spasi.
* `wildmenu`, `wildmode=list:longest` → Autocomplete command lebih nyaman.
* `wildignore` → Abaikan file tertentu di autocomplete.

### Keybinding Umum

* **Save** → `Ctrl+s`
* **Quit tanpa save** → `Ctrl+x`
* **Reload config** → `so`

---

## 🎨 Colorscheme

* Tema: `vscode.nvim`

  ```vim
  colorscheme vscode
  ```

---

## 📂 NERDTree

### Otomatis terbuka saat masuk

* `:NERDTree` terbuka saat startup.
* Jika hanya tersisa NERDTree window → Neovim otomatis `quit`.

### Keybinding

* `<leader>n` → Fokus ke NERDTree
* `Ctrl+n` → Buka NERDTree
* `Ctrl+t` → Toggle NERDTree
* `Ctrl+f` → Temukan file aktif di NERDTree
* `Ctrl+h` → Tampilkan hidden files

---

## 📑 Barbar (Bufferline)

### Navigasi Buffer

* `Alt+,` → Buffer sebelumnya
* `Alt+.` → Buffer berikutnya
* `Alt+<` → Geser buffer ke kiri
* `Alt+>` → Geser buffer ke kanan
* `Alt+1..9` → Lompat ke buffer ke-n
* `Alt+0` → Buffer terakhir
* `Alt+p` → Pin/unpin buffer
* `Alt+c` → Tutup buffer
* `Alt+r` → Restore buffer terakhir

### Buffer Picker

* `Ctrl+p` → Pilih buffer
* `Ctrl+Shift+p` → Hapus buffer lewat picker

### Sort Buffer

* `<Space>bb` → Berdasarkan nomor buffer
* `<Space>bn` → Berdasarkan nama
* `<Space>bd` → Berdasarkan direktori
* `<Space>bl` → Berdasarkan bahasa
* `<Space>bw` → Berdasarkan nomor window

---

## 🧠 LSP & Autocompletion

### LSP yang sudah di-setup:

* **C#** → Omnisharp
* **Rust** → rust-analyzer
* **C/C++** → clangd

### Fitur LSP

* Diagnostic:

  * `[d` → Previous diagnostic
  * `]d` → Next diagnostic
  * `<leader>e` → Buka diagnostic popup
* Go to definition:

  * `gd` → Lompat ke definisi
* Hover:

  * `K` → Tampilkan dokumentasi simbol
* Rename:

  * `<leader>fn`
* Code Action:

  * `<leader>ca`
* Formatting:

  * `<leader>fa`

### Autoformat on Save

* Berlaku untuk: `*.c, *.cpp, *.h, *.hpp`

---

## 🔍 Telescope

* `<leader>ff` → Cari file
* `<leader>fg` → Live grep
* `<leader>fb` → Cari buffer
* `<leader>fh` → Cari help tags

---

## 💬 Comment.nvim

* `Ctrl+/` → Toggle comment (line atau visual mode)

---

## 🛠️ Tips

1. Untuk install plugin → Jalankan:

   ```
   :PlugInstall
   ```
2. Untuk update plugin → Jalankan:

   ```
   :PlugUpdate
   ```
3. Untuk reload config tanpa restart → `so`

---


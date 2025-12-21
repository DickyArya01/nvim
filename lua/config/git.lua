-- Git integration configuration

local M = {}

function M.setup()
  print(" ⴵ Setting up Git integration...")

  -- ============================================
  -- 1. GITSIGNS.NVIM SETUP (Inline git signs)
  -- ============================================
  local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
  if gitsigns_ok then
    gitsigns.setup({
      -- Simple configuration
      signs              = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '▁' },
        topdelete    = { text = '▔' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn         = true,
      numhl              = false,
      linehl             = false,
      current_line_blame = false,

      on_attach          = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']h', bang = true })
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk('next')
          end
        end, { desc = "Next git hunk" })
        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[h', bang = true })
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk('prev')
          end
        end, { desc = "Previous git hunk" })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Reset hunk" })
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)

        -- Preview
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = "Git blame" })

        -- Diff
        map('n', '<leader>hd', gitsigns.diffthis, { desc = "Diff this" })

        -- Toggle
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })
      end
    })

    print("   • gitsigns.nvim configured")
  else
    print("   • gitsigns.nvim not available")
  end

  -- ============================================
  -- 2. RESOLVE CONFLICTS
  -- ============================================

  local conflict_ok, git_conflict = pcall(require, 'git-conflict')
  if conflict_ok then
    git_conflict.setup({
      default_mappings = false, -- Disable default mappings, we'll make our own
      default_commands = true,  -- Enable default commands
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      },
      debug = false,
    })

    print("   • git-conflict.nvim configured")

    -- Conflict resolution keymaps
    vim.keymap.set('n', '<leader>gco', '<cmd>GitConflictListQf<CR>',
      { desc = "List all conflicts (quickfix)" })
    vim.keymap.set('n', '<leader>gcn', '<cmd>GitConflictNextConflict<CR>',
      { desc = "Go to next conflict" })
    vim.keymap.set('n', '<leader>gcp', '<cmd>GitConflictPrevConflict<CR>',
      { desc = "Go to previous conflict" })
    vim.keymap.set('n', '<leader>gcb', '<cmd>GitConflictChooseBoth<CR>',
      { desc = "Choose both changes" })
    vim.keymap.set('n', '<leader>gci', '<cmd>GitConflictChooseIncoming<CR>',
      { desc = "Choose incoming change" })
    vim.keymap.set('n', '<leader>gcc', '<cmd>GitConflictChooseCurrent<CR>',
      { desc = "Choose current change" })
    vim.keymap.set('n', '<leader>gcn', '<cmd>GitConflictChooseNone<CR>',
      { desc = "Choose none (delete)" })
    vim.keymap.set('n', '<leader>gcr', '<cmd>GitConflictRefresh<CR>',
      { desc = "Refresh conflict view" })
  else
    print("   • git-conflict.nvim not available")
  end

  -- ============================================
  -- 3. GLOBAL GIT KEYMAPS
  -- ============================================


  -- Git status (fugitive)
  vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = "Git status" })
  vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = "Git commit" })
  vim.keymap.set('n', '<leader>gcu', ':!git reset --soft HEAD~1<CR>', { desc = "Git undo commit" })
  vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = "Git push" })
  vim.keymap.set('n', '<leader>gP', ':Git pull<CR>', { desc = "Git pull" })

  -- Browse
  vim.keymap.set('n', '<leader>gl', ':Git log<CR>', { desc = "Git log" })
  vim.keymap.set('n', '<leader>gB', ':Git branch<CR>', { desc = "Git branches" })
  vim.keymap.set('n', '<leader>gf', ':Git fetch<CR>', { desc = "Git fetch" })
  vim.keymap.set('n', '<leader>gF', ':Git pull --rebase<CR>', { desc = "Git pull rebase" })

  -- Stage/Unstage
  vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = "Git add current file" })
  vim.keymap.set('n', '<leader>gu', ':Git reset %<CR>', { desc = "Git unstage current file" })
  vim.keymap.set('n', '<leader>gU', ':Git checkout -- %<CR>', { desc = "Git discard changes" })


  -- ============================================
  -- 4. CUSTOM FUNCTIONS
  -- ============================================

  -- Function to show current git branch
  _G.get_git_branch = function()
    local handle = io.popen('git branch --show-current 2>/dev/null')
    if handle then
      local result = handle:read("*a")
      handle:close()
      result = result:gsub('\n$', '')
      if result ~= "" then
        return " " .. result
      end
    end
    return ""
  end

  -- ============================================
  -- 5. TEST IF GIT IS WORKING
  -- ============================================

  -- Test git integration
  vim.defer_fn(function()
    local test_file = vim.fn.expand('%:p')
    if test_file ~= "" and vim.fn.filereadable(test_file) == 1 then
      local handle = io.popen('git rev-parse --is-inside-work-tree 2>/dev/null')
      if handle then
        local result = handle:read("*a")
        handle:close()
        if result:match("true") then
          print("   Git repository detected")
          print("   Try these commands in a git file:")
          print("   • ]h / [h - Navigate changes")
          print("   • <leader>hs - Stage current change")
          print("   • <leader>gs - Git status")
        end
      end
    end
  end, 100)

  print(" ✔ Git module loaded successfully!")
end

return M

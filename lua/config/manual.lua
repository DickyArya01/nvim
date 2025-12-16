-- Manual

local M = {}

-- Function to read manual file
local function read_manual_file(path)
  local file = io.open(path, "r")
  if not file then
    return { "Cannot read file: " .. path }
  end

  local content = file:read("*all")
  file:close()

  local lines = vim.split(content, "\n", { plain = true })

  local preview = {}
  for i = 1, math.min(40, #lines) do
    table.insert(preview, lines[i])
  end

  -- if #lines > 40 then
    -- table.insert(preview, "")
    -- table.insert(preview, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    -- table.insert(preview, "📄 Preview truncated. Open file for full content.")
  -- end

  return preview
end

-- Function to get all manual files
local function get_manual_files()
  local manuals_dir = vim.fn.stdpath('config') .. '/manuals/'
  
  -- Create directory if not exists
  if vim.fn.isdirectory(manuals_dir) == 0 then
    vim.fn.mkdir(manuals_dir, "p")
    print("🗁 Created manuals directory: " .. manuals_dir)
  end
  
  -- Get all .txt files
  local files = vim.fn.glob(manuals_dir .. "*.txt", false, true)
  
  -- If no .txt files, check for .md files
  if #files == 0 then
    files = vim.fn.glob(manuals_dir .. "*.md", false, true)
  end
  
  return files, manuals_dir
end

-- Main function: Show manuals from files
function M.show_manuals_from_files()
  local files, manuals_dir = get_manual_files()
  
  if #files == 0 then
    print("No manual files found in: " .. manuals_dir)
    print("Creating default manual...")
    
    -- Create default manual
    local default_path = manuals_dir .. "nvim_manual.txt"
    os.execute("cp /dev/null " .. default_path)  -- Create empty file
    
    -- Add default content
    local default_content = [[# Neovim Manual
    
Add your manual content here...

## Available Shortcuts
- <leader>mm: Show this manual
- <leader>ff: Find files
- <leader>fg: Live grep
    
Edit this file at: ]] .. default_path
    
    local file = io.open(default_path, "w")
    if file then
      file:write(default_content)
      file:close()
      print("Created default manual: " .. default_path)
      files = {default_path}
    else
      print("Failed to create manual")
      return
    end
  end
  
  -- Prepare entries
  local entries = {}
  for _, filepath in ipairs(files) do
    local filename = vim.fn.fnamemodify(filepath, ":t")
    local preview = read_manual_file(filepath)
    
    -- Get title from first line
    local title = filename:gsub("%.txt$", ""):gsub("%.md$", ""):gsub("_", " ")
    if #preview > 0 and preview[1]:match("^#%s+(.+)") then
      title = preview[1]:match("^#%s+(.+)")
    end
    
    table.insert(entries, {
      path = filepath,
      filename = filename,
      title = title,
      preview = preview,
    })
  end
  
  -- Sort alphabetically
  table.sort(entries, function(a, b)
    return a.filename:lower() < b.filename:lower()
  end)
  
  -- Check Telescope
  local telescope_ok, _ = pcall(require, 'telescope')
  if not telescope_ok then
    print("Telescope not available")
    print("\nAvailable Manuals:")
    for i, entry in ipairs(entries) do
      print(string.format("  %d. %s - %s", i, entry.filename, entry.title))
    end
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_layout = require("telescope.actions.layout")
  local action_state = require('telescope.actions.state')
  local previewers = require('telescope.previewers')
  
  pickers.new({}, {
    prompt_title = "Manual Files",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = "・" .. entry.filename,
          ordinal = entry.filename .. " " .. entry.title,
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = "Preview",
      define_preview = function(self, entry)
        local preview_lines = entry.value.preview or {"Loading preview..."}
        
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
        
        -- Set filetype based on extension
        if entry.value.filename:match("%.txt$") then
          vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'markdown')  -- Treat .txt as markdown
        elseif entry.value.filename:match("%.md$") then
          vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'markdown')
        end
        
        -- Add highlight for title
        if #preview_lines > 0 then
          vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Title", 0, 0, -1)
        end
      end
    }),
    layout_config = {
      width = 0.9,
      height = 0.8,
      preview_width = 0.6,
    },
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<C-j>", actions.preview_scrolling_down)
      map("i", "<C-k>", actions.preview_scrolling_up)

      map("n", "<C-j>", actions.preview_scrolling_down)
      map("n", "<C-k>", actions.preview_scrolling_up)

      -- Enter: Open file
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection and selection.value then
          vim.cmd("vsplit " .. vim.fn.fnameescape(selection.value.path))
        end
      end)
      
      map('n', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection and selection.value then
          vim.cmd("vsplit " .. vim.fn.fnameescape(selection.value.path))
        end
      end)
      
      -- Ctrl-e: Edit file
      map('i', '<C-e>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection and selection.value then
          vim.cmd("edit " .. vim.fn.fnameescape(selection.value.path))
        end
      end)
      
      map('n', '<C-e>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection and selection.value then
          vim.cmd("edit " .. vim.fn.fnameescape(selection.value.path))
        end
      end)
      
      -- Escape/q to close
      map('i', '<Esc>', actions.close)
      map('n', '<Esc>', actions.close)
      map('i', 'q', actions.close)
      map('n', 'q', actions.close)
      
      return true
    end,
  }):find()
end

-- Function to create new manual
function M.create_new_manual()
  local _, manuals_dir = get_manual_files()
  
  -- Get manual name
  local manual_name = vim.fn.input("Manual name (without extension): ")
  if manual_name == "" then return end
  
  local filepath = manuals_dir .. manual_name .. ".txt"
  
  -- Check if exists
  if vim.fn.filereadable(filepath) == 1 then
    print("Manual already exists: " .. filepath)
    local choice = vim.fn.input("Overwrite? (y/N): ")
    if choice:lower() ~= "y" then return end
  end
  
  -- Create with template
  local template = [[# ]] .. manual_name:gsub("_", " "):gsub("^%l", string.upper) .. [[

## Overview
Add your manual content here...

## Shortcuts
- <shortcut>: Description

## Usage Examples

---

> Created: ]] .. os.date("%Y-%m-%d") .. [[
> Location: ]] .. filepath
  
  local file = io.open(filepath, "w")
  if file then
    file:write(template)
    file:close()
    print("Created manual: " .. filepath)
    
    -- Open for editing
    vim.cmd("edit " .. vim.fn.fnameescape(filepath))
  else
    print("Failed to create manual")
  end
end

-- Function to edit specific manual
function M.edit_manual()
  local files, _ = get_manual_files()
  
  if #files == 0 then
    print("No manual files found")
    return
  end
  
  -- Simple selection
  print("\nSelect manual to edit:")
  for i, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t")
    print(string.format("  %d. %s", i, name))
  end
  
  local choice = vim.fn.input("\nEnter number: ")
  local num = tonumber(choice)
  
  if num and num >= 1 and num <= #files then
    vim.cmd("edit " .. vim.fn.fnameescape(files[num]))
  else
    print("Invalid selection")
  end
end

-- Setup function
function M.setup()
  print(" ✎ Setting up Manual...")

  -- Browse manuals from files
  vim.keymap.set('n', '<leader>mm', M.show_manuals_from_files, {
    desc = "Browse manual files"
  })
  
  -- Create new manual
  vim.keymap.set('n', '<leader>mn', M.create_new_manual, {
    desc = "Create new manual"
  })
  
  -- Edit manual
  vim.keymap.set('n', '<leader>me', M.edit_manual, {
    desc = "Edit manual"
  })
  
  print("   • Manuals module loaded (file-based):")
  print("   • <leader>mm - Browse manual files")
  print("   • <leader>mn - Create new manual")
  print("   • <leader>me - Edit manual")
  print("   • <C-j> - Scroll down preview")
  print("   • <C-k> - Scroll up preview")
  print("   • Location: ~/.config/nvim/manuals/")
end

return M

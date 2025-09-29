require('telescope').setup({
  defaults = {
    case_mode = "smart_case",
  }
})

-- Load workspaces extension
require('telescope').load_extension('workspaces')

local builtin = require('telescope.builtin')

-- Dynamic additional search directories
local additional_dirs = {}

-- Helper function to get all search directories
local function get_search_dirs()
  local dirs = { vim.fn.getcwd() } -- Always include current directory
  for _, dir in ipairs(additional_dirs) do
    table.insert(dirs, vim.fn.expand(dir))
  end
  return dirs
end

-- Add directory to search path
vim.keymap.set('n', '<leader>fa', function()
  local dir = vim.fn.input("Add directory to search: ", "", "dir")
  if dir ~= "" then
    table.insert(additional_dirs, dir)
    print("Added " .. dir .. " to search directories")
  end
end, { desc = "Add directory to search" })

-- Remove directory from search path
vim.keymap.set('n', '<leader>fr', function()
  if #additional_dirs == 0 then
    print("No additional directories to remove")
    return
  end
  
  local choices = {}
  for i, dir in ipairs(additional_dirs) do
    table.insert(choices, i .. ": " .. dir)
  end
  
  local choice = vim.fn.inputlist(vim.list_extend({"Select directory to remove:"}, choices))
  if choice > 0 and choice <= #additional_dirs then
    local removed = table.remove(additional_dirs, choice)
    print("Removed " .. removed .. " from search directories")
  end
end, { desc = "Remove directory from search" })

-- Show current search directories
vim.keymap.set('n', '<leader>fs', function()
  local lines = { "Search directories:" }
  table.insert(lines, "  1: " .. vim.fn.getcwd() .. " (current)")
  for i, dir in ipairs(additional_dirs) do
    table.insert(lines, "  " .. (i + 1) .. ": " .. vim.fn.expand(dir))
  end
  if #additional_dirs == 0 then
    table.insert(lines, "  (no additional directories)")
  end
  
  vim.api.nvim_echo(vim.tbl_map(function(line) return {line, "Normal"} end, lines), true, {})
end, { desc = "Show search directories" })

vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    search_dirs = get_search_dirs()
  })
end, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>fw', function()
  builtin.live_grep({
    search_dirs = get_search_dirs()
  })
end)

vim.api.nvim_create_user_command('LS', function()
    require('telescope.builtin').buffers()
end, {})

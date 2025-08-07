-- Claude CLI integration for Neovim
local M = {}

-- Function to open Claude CLI in a terminal window
function M.open_claude()
    -- Get the current working directory 
    local cwd = vim.fn.getcwd()
    
    -- Create a new window split (vertical split on the right)
    vim.cmd('vsplit')
    
    -- Open terminal with Claude CLI
    vim.cmd('terminal claude')
    
    -- Enter insert mode in the terminal
    vim.cmd('startinsert')
end

-- Set up the keybinding
function M.setup()
    vim.keymap.set('n', '<leader>aa', M.open_claude, { 
        noremap = true, 
        silent = true,
        desc = "Open Claude CLI in terminal window"
    })
end

return M
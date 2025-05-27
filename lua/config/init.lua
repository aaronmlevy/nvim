-- Line numbers
vim.opt.number = true
vim.g.mapleader = " "

-- Escape
vim.keymap.set("i", "jj", "<Esc>")

-- Black
vim.keymap.set('n', '<leader>b', ':w<CR>:! /home/aaron/.pyenv/shims/black --target-version=py36 --line-length=95 %:p<CR>', {noremap = true})
vim.keymap.set('n', '<leader>l', ':w<CR>:cgetexpr system("flake8 " . shellescape(expand("%:p")))<CR>:copen<CR>', { noremap = true, silent = true })


-- Clipboard
--vim.opt.clipboard:append("unnamedplus")


-- Buffer navigation
vim.keymap.set('n', 't', ':bnext<CR>', {noremap = true})
vim.keymap.set('n', 'T', ':bprevious<CR>', {noremap = true})

-- Buffer delete
vim.keymap.set('n', '<C-w>', ':BD!<CR>', {noremap = true})

-- Comment out or remove EasyMotion config
-- vim.g.EasyMotion_smartcase = 1
-- vim.g.EasyMotion_do_mapping = 0
-- vim.keymap.set('n', '/', '<Plug>(easymotion-sn)')


-- Navigation 
vim.keymap.set('n', '<C-j>', '<C-W>j', {noremap = true})
vim.keymap.set('n', '<C-k>', '<C-W>k', {noremap = true})
vim.keymap.set('n', '<C-l>', '<C-W>l', {noremap = true})
vim.keymap.set('n', '<C-h>', '<C-W>h', {noremap = true})

-- Don't move the mouse on scroll
vim.o.mouse = 'a'

-- Always show relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Set ipython paste 
vim.keymap.set('n', '<leader>i', ':if g:slime_python_ipython == 1 | let g:slime_python_ipython=0 | else | let g:slime_python_ipython=1 | endif<CR>', {noremap = true})

-- Set paste, nopaste
vim.keymap.set('n', '<leader>p', ':if &paste | set nopaste | else | set paste | endif<CR>', {noremap = true})

-- Set tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Equal window width
vim.keymap.set('n', '=', ':wincmd=<CR>', {noremap = true})

-- Python debug
vim.keymap.set('n', '<leader>db', 'oimport pdb; pdb.set_trace()<Esc>', {noremap = true})

-- Make j and k trigger the jump list so you can go back with ctrl-o and ctrl-i
vim.keymap.set('n', 'k', "v:count > 1 ? \"m'\" .. v:count .. 'k' : 'gk'", {expr = true, noremap = true, silent = true})
vim.keymap.set('n', 'j', "v:count > 1 ? \"m'\" .. v:count .. 'j' : 'gj'", {expr = true, noremap = true, silent = true})

-- Ensure relative numbers stay on, even if something tries to turn them off
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    callback = function()
      if vim.wo.number then
        vim.opt.relativenumber = true
      end
    end
  })


require("config.matlab").setup()

vim.keymap.set("v", "<leader>b", function()
    -- Always use the current visual selection
    vim.cmd('normal! gv')
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local end_line = end_pos[2]
    if start_line > end_line then start_line, end_line = end_line, start_line end

    -- Get the selected lines
    local lines = vim.fn.getline(start_line, end_line)
    local text = table.concat(lines, " ")
    text = text:gsub("%s*;%s*$", "")  -- Remove trailing semicolon if any

    -- Build formatted output
    local formatted = {}
    local var_name = text:match("^%s*([^=]+)%s*=")
    if var_name then
        table.insert(formatted, var_name .. " = (...")
    else
        table.insert(formatted, "(...")
    end
    
    -- Extract the part after equals
    local expr_part = text:match("=%s*(.+)$") or text
    
    -- Split by top-level dots
    local parts = {}
    local i = 1
    local current_part = ""
    local paren_level = 0
    
    while i <= #expr_part do
        local char = expr_part:sub(i, i)
        
        if char == "(" then
            paren_level = paren_level + 1
            current_part = current_part .. char
        elseif char == ")" then
            paren_level = paren_level - 1
            current_part = current_part .. char
        elseif char == "." and paren_level == 0 then
            -- Found top-level dot
            if current_part ~= "" then
                table.insert(parts, current_part)
                current_part = ""
            end
        else
            current_part = current_part .. char
        end
        i = i + 1
    end
    
    if current_part ~= "" then
        table.insert(parts, current_part)
    end
    
    -- Format each part
    for i, part in ipairs(parts) do
        part = part:gsub("^%s+", ""):gsub("%s+$", "")
        if i == 1 then
            -- First part (base object)
            table.insert(formatted, string.rep(" ", 4) .. part .. "...")
        else
            -- Method call
            local func_name, args = part:match("^([%w_]+)%s*%((.*)%)$")
            if func_name then
                -- Args might be an empty string for methods with no arguments
                if args == "" then
                    -- Method with empty parentheses
                    table.insert(formatted, string.rep(" ", 4) .. "." .. func_name .. "()...")
                else
                    -- Check if we should split args
                    local should_split = args:find(",") or #args > 30
                    
                    if should_split then
                        table.insert(formatted, string.rep(" ", 4) .. "." .. func_name .. "(...")
                        -- Parse and split arguments
                        local arg_list = {}
                        local current_arg = ""
                        local arg_paren_level = 0
                        local j = 1
                        
                        while j <= #args do
                            local c = args:sub(j, j)
                            
                            if c == "(" then
                                arg_paren_level = arg_paren_level + 1
                                current_arg = current_arg .. c
                            elseif c == ")" then
                                arg_paren_level = arg_paren_level - 1
                                current_arg = current_arg .. c
                            elseif c == "," and arg_paren_level == 0 then
                                -- End of argument
                                table.insert(arg_list, current_arg)
                                current_arg = ""
                            else
                                current_arg = current_arg .. c
                            end
                            j = j + 1
                        end
                        
                        if current_arg ~= "" then
                            table.insert(arg_list, current_arg)
                        end
                        
                        -- Format each argument
                        for i, arg in ipairs(arg_list) do
                            arg = arg:gsub("^%s+", ""):gsub("%s+$", "")
                            if i == #arg_list then
                                -- Last argument - no comma
                                table.insert(formatted, string.rep(" ", 8) .. arg .. "...")
                            else
                                -- Not the last argument - add comma
                                table.insert(formatted, string.rep(" ", 8) .. arg .. ",...")
                            end
                        end
                        
                        table.insert(formatted, string.rep(" ", 4) .. ")...")
                    else
                        -- Short arguments - keep on one line
                        table.insert(formatted, string.rep(" ", 4) .. "." .. func_name .. "(" .. args .. ")...")
                    end
                end
            else
                -- Property access or method without parentheses
                table.insert(formatted, string.rep(" ", 4) .. "." .. part .. "...")
            end
        end
    end
    
    table.insert(formatted, ");")

    -- Replace the selected lines with the formatted block
    if start_line <= end_line and start_line > 0 then
        -- Ensure valid line range before setting lines
        local valid_start = start_line - 1
        local valid_end = end_line
        
        -- Additional safeguard to ensure start < end
        if valid_start < valid_end then
            vim.api.nvim_buf_set_lines(0, valid_start, valid_end, false, formatted)
            
            -- Exit visual mode using feedkeys
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
            
            -- Set cursor to the start of the formatted block
            vim.api.nvim_win_set_cursor(0, {start_line, 0})
        else
            print("Invalid selection range: start must be less than end")
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
        end
    else
        print("Invalid selection: please select text before using this command")
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
    end
end, { desc = "Format MATLAB-compatible Python block with indent" })


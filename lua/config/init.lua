-- Line numbers
vim.opt.number = true
vim.g.mapleader = " "

-- Smart case search
vim.opt.ignorecase = true
vim.opt.smartcase = true

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

-- Diagnostic float
vim.keymap.set('n', '?', vim.diagnostic.open_float, {noremap = true})

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
require("config.claude_cli").setup()

vim.keymap.set("v", "<leader>b", function()
    -- Force update of visual marks and get fresh selection
    vim.cmd('normal! gv')
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    
    -- Exit visual mode to clear selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    
    -- Ensure start_line <= end_line
    if start_line > end_line then 
        start_line, end_line = end_line, start_line 
    end

    -- Validate line numbers
    if start_line <= 0 or end_line <= 0 then
        print("Invalid selection")
        return
    end

    local lines = vim.fn.getline(start_line, end_line)
    if #lines == 0 then
        print("No lines selected")
        return
    end
    
    local text = table.concat(lines, "\n")
    local filetype = vim.bo.filetype

    -- Simple Python formatting
    if filetype == "python" then
        -- Temp file
        local tmpname = vim.fn.tempname() .. ".py"
        local tmpfile = io.open(tmpname, "w")
        if not tmpfile then
            print("Failed to create temp file")
            return
        end
        tmpfile:write(text)
        tmpfile:close()

        -- Run Black and capture output
        local black_cmd = string.format("/home/aaron/.pyenv/shims/black --target-version=py36 --line-length=95 %s 2>&1", tmpname)
        local handle = io.popen(black_cmd)
        local black_output = handle:read("*a")
        handle:close()
        
        -- Check if the file was actually formatted by trying to read it
        local formatted_file = io.open(tmpname, "r")
        if not formatted_file then
            print("Black formatting failed - could not read formatted file")
            if black_output and black_output ~= "" then
                print("Black output:")
                print(black_output)
            end
            os.remove(tmpname)
            return
        end
        formatted_file:close()
        
        -- If there's any output from Black, it might be an error or warning
        if black_output and black_output ~= "" and not black_output:match("^reformatted") then
            print("Black output:")
            print(black_output)
        end
        
        -- Read formatted result
        local new_lines = {}
        for line in io.lines(tmpname) do
            table.insert(new_lines, line)
        end
        
        -- Replace selection with formatted code
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
        vim.api.nvim_win_set_cursor(0, {start_line, 0})
        os.remove(tmpname)
        return
    end

    -- MATLAB/other filetypes: use existing complex processing
    -- Preprocess: replace { } with [ ]
    local preprocessed_text = text:gsub("{", "["):gsub("}", "]")

    -- Temp file
    local tmpname = vim.fn.tempname() .. ".py"
    local tmpfile = io.open(tmpname, "w")
    if not tmpfile then
        print("Failed to create temp file")
        return
    end
    tmpfile:write(preprocessed_text)
    tmpfile:close()

    -- Run Black and capture output
    local black_cmd = string.format("/home/aaron/.pyenv/shims/black --target-version=py36 --line-length=95 --skip-magic-trailing-comma %s 2>&1", tmpname)
    local handle = io.popen(black_cmd)
    local black_output = handle:read("*a")
    handle:close()
    
    -- Check if the file was actually formatted by trying to read it
    local formatted_file = io.open(tmpname, "r")
    if not formatted_file then
        print("Black formatting failed - could not read formatted file")
        if black_output and black_output ~= "" then
            print("Black output:")
            print(black_output)
        end
        os.remove(tmpname)
        return
    end
    formatted_file:close()
    
    -- If there's any output from Black, it might be an error or warning
    if black_output and black_output ~= "" and not black_output:match("^reformatted") then
        print("Black output:")
        print(black_output)
    end
    
    -- Read result and add ellipses intelligently
    local new_lines = {}
    local formatted_lines = {}
    for line in io.lines(tmpname) do
        table.insert(formatted_lines, line)
    end
    
    for i, line in ipairs(formatted_lines) do
        local next_line = formatted_lines[i + 1]
        
        -- Post-process: change [ ] back to { }
        line = line:gsub("%[", "{"):gsub("%]", "}")
        
        -- Remove trailing comma if next line is just a closing paren/bracket/brace
        if line:match(",%s*$") and next_line and next_line:match("^%s*[%)%]%}]%s*$") then
            line = line:gsub(",%s*$", "")
        end
        
        if line:match("^%s*$") then
            -- Empty line
            table.insert(new_lines, "")
        elseif next_line and not line:match("%.%.%.$") and (
            line:match("[,\\(\\[{]%s*$") or  -- ends with comma, paren, bracket, brace
            line:match("=%s*$") or           -- ends with equals (assignment continuation)
            line:match("and%s*$") or         -- ends with 'and'
            line:match("or%s*$") or          -- ends with 'or'
            line:match("\\%s*$") or          -- ends with backslash
            (next_line and next_line:match("^%s*[.)]")) -- next line starts with dot or closing paren
        ) then
            table.insert(new_lines, line .. " ...")
        else
            -- Complete statement or already has ellipses
            table.insert(new_lines, line)
        end
    end
    
    -- Replace selection
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
    vim.api.nvim_win_set_cursor(0, {start_line, 0})
    os.remove(tmpname)
end, { desc = "Format selection: simple Black for Python, MATLAB-style processing for others" })

vim.keymap.set("v", "<leader>B", function()
    -- Force update of visual marks and get fresh selection
    vim.cmd('normal! gv')
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    
    -- Exit visual mode to clear selection
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    
    -- Ensure start_line <= end_line
    if start_line > end_line then 
        start_line, end_line = end_line, start_line 
    end

    -- Validate line numbers
    if start_line <= 0 or end_line <= 0 then
        print("Invalid selection")
        return
    end

    local lines = vim.fn.getline(start_line, end_line)
    if #lines == 0 then
        print("No lines selected")
        return
    end
    
    -- Process lines: remove ellipses and join non-empty lines
    local processed_lines = {}
    local current_statement = ""
    
    for _, line in ipairs(lines) do
        -- Remove ellipses from the end of the line
        local cleaned_line = line:gsub("%s*%.%.%.$", "")
        
        -- Skip empty lines
        if not cleaned_line:match("^%s*$") then
            if current_statement == "" then
                current_statement = cleaned_line
            else
                -- Add space if the current statement doesn't end with certain characters
                if not current_statement:match("[({[]%s*$") and not cleaned_line:match("^%s*[.)}%]]") then
                    current_statement = current_statement .. " " .. cleaned_line:gsub("^%s*", "")
                else
                    current_statement = current_statement .. cleaned_line:gsub("^%s*", "")
                end
            end
        else
            -- Empty line - finish current statement if we have one
            if current_statement ~= "" then
                table.insert(processed_lines, current_statement)
                current_statement = ""
            end
            table.insert(processed_lines, "")
        end
    end
    
    -- Don't forget the last statement
    if current_statement ~= "" then
        table.insert(processed_lines, current_statement)
    end
    
    -- Replace selection
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, processed_lines)
    vim.api.nvim_win_set_cursor(0, {start_line, 0})
end, { desc = "Remove ellipses and put code on single lines" })
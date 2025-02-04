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

-- Multi-cursor setup for VSCode
if vim.g.vscode then
    -- Basic cursor commands
    vim.keymap.set('n', '<C-f>', '<Cmd>call VSCodeNotify("editor.action.addSelectionToNextFindMatch")<CR>')
    vim.keymap.set('n', '<C-u>', '<Cmd>call VSCodeNotify("editor.action.removeSelectionFromNextFindMatch")<CR>')
    vim.keymap.set('n', '<C-A-Up>', '<Cmd>call VSCodeNotify("editor.action.selectHighlights")<CR>')
end

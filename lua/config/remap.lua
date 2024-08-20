-- Line numbers
vim.opt.number = true
vim.g.mapleader = " "

-- Escape
vim.keymap.set("i", "jj", "<Esc>")

local function split_cell()
    local buf = vim.api.nvim_get_current_buf()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, false, {"# %%"})
    vim.cmd('normal! 2j')
end
vim.keymap.set('n', '<leader>bb', split_cell, { noremap = true, silent = true })
vim.keymap.set('i', '<leader>bb', split_cell, { noremap = true, silent = true })

_G.markdown_cell = function()
    local buf = vim.api.nvim_get_current_buf()
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, false, {"# %% [markdown]", "# #", "# %%"})
    vim.cmd('normal! 2j')
    vim.cmd('startinsert!')
end
vim.cmd('command! MD lua _G.markdown_cell()')
-- Black
vim.keymap.set('n', '<leader>f', ':w<CR>:! /home/aaron/.pyenv/shims/black --target-version=py36 --line-length=95 %:p<CR>', {noremap = true})

-- Clipboard
--vim.opt.clipboard:append("unnamedplus")


-- Buffer navigation
vim.keymap.set('n', 't', ':bnext<CR>', {noremap = true})
vim.keymap.set('n', 'T', ':bprevious<CR>', {noremap = true})

-- Buffer delete
vim.keymap.set('n', '<C-w>', ':BD!<CR>', {noremap = true})

-- Easy motion
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_do_mapping = 0
vim.keymap.set('n', '<C-w>', ':BD!<CR>', {noremap = true})
vim.keymap.set('n', '/', '<Plug>(easymotion-sn)')

-- Navigation
vim.keymap.set('n', '<C-j>', '<C-W>j', {noremap = true})
vim.keymap.set('n', '<C-k>', '<C-W>k', {noremap = true})
vim.keymap.set('n', '<C-l>', '<C-W>l', {noremap = true})
vim.keymap.set('n', '<C-h>', '<C-W>h', {noremap = true})

-- Vim visual mutli config
vim.g.VM_maps = {
    ['Add Cursor Down'] = '<C-z>',
    ['Find Under'] = '<C-f>',
    ['Find Subword Under'] = '<C-f>'
}

-- Don't move the mouse on scroll
vim.o.mouse = 'a'

-- Use relative numbers
vim.opt.relativenumber = true

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

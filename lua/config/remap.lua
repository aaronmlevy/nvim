-- Line numbers
vim.opt.number = true
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")

-- Navigation
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')
vim.keymap.set('n', '<C-h>', '<C-W>h')

-- Add a # %% to start insert mode
vim.keymap.set('n', '<leader>bb', function()
    vim.api.nvim_put({'# %%'}, 'l', true, true)
    vim.cmd('startinsert')
end, { noremap = true, silent = true })

-- Black
vim.keymap.set('n', '<F3>', ':w<CR>:! /Users/aaronlevy/.pyenv/shims/black --target-version=py36 --line-length=95 %:p<CR>', {noremap = true})

vim.opt.clipboard:append("unnamedplus")


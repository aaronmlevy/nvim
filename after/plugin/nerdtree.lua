vim.g.NERDTreeMinimalUI = 1
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>n', ':NERDTreeFind<CR>', {noremap = true, silent = true})

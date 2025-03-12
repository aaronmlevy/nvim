vim.g.NERDTreeMinimalUI = 1
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>n', ':NERDTreeFind<CR>', {noremap = true, silent = true})
vim.g.NERDTreeIgnore = {'.*prof.*', '\\.prof', '__pycache__', '\\.pyc$', '\\.o$', '\\.swp',  '.*\\.swp',  'node_modules/', 'tags', '.*\\.asv*', '.*\\.egg-info*', '.*\\.egg*', '.*\\.git*', '.*\\.hg*', '.*\\.svn*', '.*\\.tox'}

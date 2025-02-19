vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1
vim.api.nvim_set_keymap('x', '<leader>x', 'ma<Plug>SlimeRegionSend', {})
vim.api.nvim_set_keymap('n', '<leader>x', 'ma<Plug>SlimeParagraphSend', {})
vim.api.nvim_set_keymap('n', '<C-v>v', '<Plug>SlimeConfig', {})
vim.g.slime_default_config = {socket_name = vim.fn.split(vim.env.TMUX, ",")[1], target_pane= ":.2"}

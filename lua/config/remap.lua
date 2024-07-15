-- Line numbers
vim.opt.number = true
vim.g.mapleader = " "

-- Escape
vim.keymap.set("i", "jj", "<Esc>")

-- Markdown for Jupyter.
local function add_magic_comment()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, -1, -1, false)
    if #lines == 0 or lines[#lines] ~= "# %%" then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"", "# %%"})
    end
    vim.cmd('startinsert')
end
vim.keymap.set('n', '\\bb', add_magic_comment, { noremap = true, silent = true })
vim.keymap.set('i', '\\bb', add_magic_comment, { noremap = true, silent = true })

-- Black
vim.keymap.set('n', '<F3>', ':w<CR>:! /home/aaron/.pyenv/shims/black --target-version=py36 --line-length=95 %:p<CR>', {noremap = true})

-- Clipboard
vim.opt.clipboard:append("unnamedplus")


-- Navigation
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')
vim.keymap.set('n', '<C-h>', '<C-W>h')


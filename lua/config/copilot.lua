vim.keymap.set('n', '<leader>cq', function()
    local input = vim.fn.input('Quick Chat: ')
    local selection_module = require('CopilotChat.select')
    local selection_table = selection_module.buffer or {default = 'value'}
    print(vim.inspect(selection_table))  -- This will confirm the table's contents
    require('CopilotChat').ask(input, {selection = selection_table})
end, { noremap = true, silent = true, desc = 'Quick Chat' })


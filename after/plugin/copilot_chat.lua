-- Map the <leader>cq to quick chat
vim.keymap.set('n', '<leader>ch', function()
	local input = vim.fn.input('Quick Chat: ')
	require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
end, { noremap = true, silent = true, desc = 'Quick Chat' })

require("CopilotChat").setup({
	window = {
		layout = 'vertical',
		relative = 'cursor',
        width=.25
	},
	mappings = {
		reset = {
			normal ='<C-r>',
		},
	},
})

-- Map the <leader>cq to quick chat
vim.keymap.set('n', '<leader>cq', function()
	local input = vim.fn.input('Quick Chat: ')
	require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
end, { noremap = true, silent = true, desc = 'Quick Chat' })

require("CopilotChat").setup({
	window = {
		layout = 'vertical',
		relative = 'cursor',
	},
	mappings = {
		reset = {
			normal ='<C-r>',
		},
	},
})

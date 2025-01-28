-- Map the <leader>ch to quick chat for visual selection
vim.keymap.set('v', '<leader>ch', function()
	require('CopilotChat').ask(input, { selection = require('CopilotChat.select').visual })
end, { noremap = true, silent = true, desc = 'Quick Chat' })

require("CopilotChat").setup({
	window = {
		layout = 'vertical',
		relative = 'cursor',
        width = .25
	},
	mappings = {
		reset = {
			normal = '<C-r>',
		},
	},
})

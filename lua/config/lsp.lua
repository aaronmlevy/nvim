local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.use('pyright')

lsp.on_attach(function(client, bufnr)
	local opts = {buffer=bufnr, remap=false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

	client.handlers["textDocument/publishDiagnostics"] = function() end
end)

lsp.setup()

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.use('pyright')

lsp.on_attach(
    function(client, bufnr)
        local opts = {buffer=bufnr, remap=false}
        client.handlers["textDocument/publishDiagnostics"] = function() end  -- Disable diagnostics
    end
)

lsp.setup()


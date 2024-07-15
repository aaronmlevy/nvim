local nvim_lsp = require('lspconfig')
nvim_lsp.pyright.setup{
    settings = {
        pyright = {
            disableDiagnostics = true
        }
    }
}


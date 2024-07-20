local lspconfig = require('lspconfig')
lspconfig.pyright.setup{
    settings = {
        pyright = {
            disableDiagnostics = true
        }
    }
}


lspconfig.matlab_ls.setup({...})


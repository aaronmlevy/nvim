local lspconfig = require('lspconfig')

lspconfig.jedi_language_server.setup{}

lspconfig.pyright.setup{
    settings = {
        pyright = {
            disableDiagnostics = true
        }
    }
}

lspconfig.matlab_ls.setup{}
lspconfig.clangd.setup({...})

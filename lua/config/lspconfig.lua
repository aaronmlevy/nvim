local lspconfig = require('lspconfig')

lspconfig.jedi_language_server.setup{}

lspconfig.pyright.setup{
    settings = {
        pyright = {
            disableDiagnostics = true
        }
    }
}

-- Configure MATLAB language server with proper capabilities
lspconfig.matlab_ls.setup{
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings for LSP functionality
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    end,
}

lspconfig.clangd.setup({...})

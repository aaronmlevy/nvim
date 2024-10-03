local lspconfig = require('lspconfig')

lspconfig.jedi_language_server.setup{}

lspconfig.pyright.setup{
    settings = {
        pyright = {
            disableDiagnostics = true
        }
    }
}


lspconfig.matlab_ls.setup{
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap=true, silent=true }

        -- Key mappings
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    end
}
lspconfig.clangd.setup({...})

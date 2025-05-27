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
    flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
    },
    on_attach = function(client, bufnr)
        print("MATLAB LSP attached!")
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings for LSP functionality
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        
        -- MATLAB line continuation
        vim.keymap.set("i", "<CR>", function()
            local line = vim.api.nvim_get_current_line()
            local trimmed = vim.trim(line)
            
            -- Don't add continuation if line already ends with ...
            if trimmed:match("%.%.%.$") then
              return "<CR>"
            end
            
            -- Check for operators that would need continuation
            if trimmed:match("[%+%-%*/%^&|=~<>]%s*$") then
              return "<Esc>A ...<CR>"
            end
            
            -- Check for unclosed brackets/parentheses
            if trimmed:match("[%(%[{]%s*$") then
              return "<Esc>A ...<CR>"
            end
            
            -- Check for comma at the end (likely in a function call or array)
            if trimmed:match(",%s*$") then
              return "<Esc>A ...<CR>"
            end
            
            -- Check for incomplete function calls
            if trimmed:match("%w+%s*%([^%)]*$") then
              return "<Esc>A ...<CR>"
            end
            
            return "<CR>"
        end, { expr = true, buffer = true })
        
        -- Add a command to restart the MATLAB language server
        vim.api.nvim_create_user_command('RestartMatlabLS', function()
            vim.cmd('LspStop matlab_ls')
            vim.defer_fn(function()
                vim.cmd('LspStart matlab_ls')
            end, 1000)
        end, {})
    end,
    settings = {
        matlab = {
            indexWorkspace = true,
            suggestionMode = true,
            -- Increase timeout values to prevent disconnections
            completionRequest = {
                timeout = 5000
            },
            diagnostics = {
                timeout = 5000
            }
        }
    }
}

lspconfig.clangd.setup({...})

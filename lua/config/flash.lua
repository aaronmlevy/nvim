local M = {}

function M.setup()
    -- Disable default operator-pending mode mappings
    require("flash").setup({
        modes = {
            ops = false,
            treesitter = true,
            char = { highlight = {backdrop=false}},
        },
        label = { after = false, before = true },

    })

    -- Flash.nvim config with full buffer search
    vim.keymap.set({'n', 'x', 'o'}, '<leader>f', function()
        require("flash").jump({
            search = {
                mode = function(str)
                    return "\\<" .. str
                end,
                forward = true,
                wrap = true,
                multi_window = true,
                max_length = 100000,  -- Search entire buffer
            },
        })
    end)
end

return M 

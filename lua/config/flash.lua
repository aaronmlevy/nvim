local M = {}

function M.setup()
    -- Flash.nvim config with multi-cursor support
    vim.keymap.set({'n', 'x', 'o'}, 'f', function()
        require("flash").jump({
            search = {
                mode = function(str)
                    return "\\<" .. str
                end,
            },
            label = { after = false, before = true },
            search = {
                forward = true,
                wrap = true,
                multi_window = false,
                max_length = 100000,  -- Search entire buffer
            },
            modes = {
                char = {
                    multi_line = false,
                    highlight = { backdrop = false },
                },
            },
            -- Add VSCode multi-cursor support
            remote_op = {
                restore = true,
                motion = true,
            },
        })
    end)

    -- Multi-cursor setup with mark-and-find
    vim.keymap.set('n', '<C-d>', 'mciw*<Cmd>nohl<CR>', { remap = true })
end

return M 
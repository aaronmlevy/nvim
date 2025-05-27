local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "matlab",
    callback = function()
      print("MATLAB filetype detected, setting up line continuation")
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
    end,
  })
end

return M 
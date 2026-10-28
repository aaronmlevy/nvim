-- Scratch buffers: :Scratch [py|m] opens a new unsaved buffer named
-- scratch_N.<ext>, picking N so the name collides with no existing file
-- or buffer. Nothing touches disk until you :w explicitly.

local M = {}

local filetypes = { py = "python", m = "matlab" }

local function next_free_name(ext)
  local n = 1
  while true do
    -- Absolute path so the :w target is fixed at creation, not at save time
    local name = vim.fn.fnamemodify(string.format("scratch_%d.%s", n, ext), ":p")
    if vim.fn.filereadable(name) == 0 and vim.fn.bufexists(name) == 0 then
      return name
    end
    n = n + 1
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Scratch", function(opts)
    local ext = opts.args ~= "" and opts.args or nil
    if not ext then
      for e, ft in pairs(filetypes) do
        if ft == vim.bo.filetype then ext = e end
      end
      if not ext then
        print("Can't infer scratch type from filetype '" .. vim.bo.filetype
          .. "' - use :Scratch py or :Scratch m")
        return
      end
    end
    if not filetypes[ext] then
      print("Unknown scratch type '" .. ext .. "' - use py or m")
      return
    end
    local name = next_free_name(ext)
    vim.cmd.enew()
    vim.api.nvim_buf_set_name(0, name)
    vim.bo.filetype = filetypes[ext]
  end, {
    nargs = "?",
    complete = function() return { "py", "m" } end,
    desc = "New unsaved scratch buffer (py or m); written only on explicit :w",
  })
end

return M

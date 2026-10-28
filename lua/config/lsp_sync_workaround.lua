-- Workaround for neovim/neovim#33224 / #24972 (present in 0.11.4):
-- incremental LSP sync crashes with "attempt to get length of local
-- 'prev_line'" when a client's buffer snapshot desyncs, and because the
-- crash happens before the snapshot is updated, every subsequent edit
-- crashes again. Catch it, detach/reattach the buffer's clients (which
-- rebuilds the snapshot from the real buffer), and log which buffer and
-- clients were involved so the root cause can be identified.
-- Remove once the upstream bug is fixed.

local ok_mod, changetracking = pcall(require, "vim.lsp._changetracking")
if not ok_mod or type(changetracking.send_changes) ~= "function" then
  vim.notify("lsp_sync_workaround: vim.lsp._changetracking not patchable; workaround inactive", vim.log.levels.WARN)
  return
end

local orig_send_changes = changetracking.send_changes
local resync_pending = {}

changetracking.send_changes = function(bufnr, firstline, lastline, new_lastline)
  local ok, err = pcall(orig_send_changes, bufnr, firstline, lastline, new_lastline)
  if ok then
    return
  end

  if resync_pending[bufnr] then
    return
  end
  resync_pending[bufnr] = true

  vim.schedule(function()
    resync_pending[bufnr] = nil
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local names = {}
    for _, c in ipairs(clients) do
      table.insert(names, string.format("%s(%s)", c.name, c.offset_encoding))
    end

    local msg = string.format(
      "[lsp_sync_workaround] caught sync desync (nvim #33224): buf=%d name=%s ft=%s buftype=%s clients=[%s] — resynced by reattach.\n%s",
      bufnr,
      vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"),
      vim.bo[bufnr].filetype,
      vim.bo[bufnr].buftype,
      table.concat(names, ", "),
      tostring(err)
    )
    vim.notify(msg, vim.log.levels.WARN)

    for _, c in ipairs(clients) do
      vim.lsp.buf_detach_client(bufnr, c.id)
      vim.lsp.buf_attach_client(bufnr, c.id)
    end
  end)
end

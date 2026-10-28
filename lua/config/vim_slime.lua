vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1

-- Save full jumplist snapshot when entering visual mode
local saved_jumplist = nil
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:[vV\x16]*',
  callback = function()
    saved_jumplist = vim.deepcopy(vim.fn.getjumplist()[1])
  end,
})

vim.keymap.set('x', '<leader>x', function()
  local v_start = vim.fn.getpos('v')
  local v_end = vim.fn.getpos('.')
  if v_start[2] > v_end[2] then v_start, v_end = v_end, v_start end
  local old_jumps = saved_jumplist
  saved_jumplist = nil

  -- Send selection via slime (feedkeys preserves visual mode context)
  local keys = vim.api.nvim_replace_termcodes('<Plug>SlimeRegionSend', true, true, true)
  vim.api.nvim_feedkeys(keys, 'mx', false)

  vim.schedule(function()
    if not old_jumps then return end
    local bufnr = vim.api.nvim_get_current_buf()
    local view = vim.fn.winsaveview()
    local saved_lz = vim.o.lazyredraw
    vim.o.lazyredraw = true

    vim.cmd('clearjumps')

    -- Collect: old same-buffer entries, then sel_end, then sel_start
    local positions = {}
    for _, j in ipairs(old_jumps) do
      if j.bufnr == bufnr then
        table.insert(positions, j.lnum)
      end
    end
    table.insert(positions, v_end[2])
    table.insert(positions, v_start[2])

    -- Replay: keepjumps to first, then real jumps to each subsequent
    -- Each G adds the *previous* position to the jumplist
    if #positions > 0 then
      vim.cmd('keepjumps normal! ' .. positions[1] .. 'G')
      for i = 2, #positions do
        vim.cmd('normal! ' .. positions[i] .. 'G')
      end
    end

    -- Mark a at bottom of selection
    vim.api.nvim_buf_set_mark(0, 'a', v_end[2], v_end[3] - 1, {})
    vim.o.lazyredraw = saved_lz
    -- Restore scroll position (cursor line set by last G, but topline/viewport preserved)
    view.lnum = v_start[2]
    vim.fn.winrestview(view)
  end)
end, { silent = true })

vim.api.nvim_set_keymap('n', '<leader>x', 'ma<Plug>SlimeParagraphSend', {})
vim.api.nvim_set_keymap('n', '<C-v>v', '<Plug>SlimeConfig', {})
vim.g.slime_default_config = {socket_name = vim.fn.split(vim.env.TMUX, ",")[1], target_pane= ":.2"}

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

-- <leader>r: pick which REPL this buffer slimes into. Lists tmux panes (any session/window)
-- running python/ipython or MATLAB, or titled repl-* (shared Claude REPLs), then bash shells
-- (shown with their cwd). Choice is buffer-local.
local function pick_slime_target()
  local fmt = '#{pane_id}\t#{pane_title}\t#{pane_current_command}\t#{session_name}:#{window_index}\t#{pane_current_path}'
  local lines = vim.fn.systemlist({ 'tmux', 'list-panes', '-a', '-F', fmt })
  local repls, shells = {}, {}
  for _, l in ipairs(lines) do
    local id, title, cmd, where, path = l:match('^(%S+)\t(.-)\t(%S*)\t(%S+)\t(.*)$')
    if id and id ~= vim.env.TMUX_PANE then
      -- tmux's default title is the hostname: show the cwd instead
      if title == vim.fn.hostname() or title == '' then title = vim.fn.fnamemodify(path, ':~') end
      if cmd:match('python') or cmd:lower():match('matlab') or title:match('^repl%-') then
        table.insert(repls, { id = id, label = string.format('%-5s %-8s %-20s %s', id, cmd, title, where) })
      elseif cmd == 'bash' or cmd == 'zsh' then
        table.insert(shells, { id = id, label = string.format('%-5s %-8s %-20s %s', id, cmd, title, where) })
      end
    end
  end
  local panes = vim.list_extend(repls, shells)
  if #panes == 0 then return vim.notify('No REPL or shell panes found', vim.log.levels.WARN) end
  vim.ui.select(panes, { prompt = 'Slime target', format_item = function(p) return p.label end }, function(p)
    if not p then return end
    vim.b.slime_config = { socket_name = vim.g.slime_default_config.socket_name, target_pane = p.id }
    vim.notify('Slime → ' .. p.label)
  end)
end
vim.keymap.set('n', '<leader>r', pick_slime_target, { desc = 'Pick slime REPL pane' })

local Utils = require('util')
local NAVIGATION_TAPS_MODE = 1
local NAVIGATION_LOC_LIST_MODE = 2
local NAVIGATION_QUICK_LIST_MODE = 3
local MODE_NAMES = { 'TABS', 'LocList', 'QuickList' }

-- In lua/keys.lua
local actions
local action_state
local builtin
local M = {}

function M.setup()
  M.setup_mode_keybind()
  M.setup_navigation_keybind()
  M.setup_resize_keybind()
  M.setup_fix_list_navigation_keybind()
  M.setup_fix_list_toggle_keybind()
  M.setup_arabic_keybind()

  -- M.setup_fix_list_diagnostic_keybind()
  -- M.set_yz_keybind()
end

function M.setup_mode_keybind()
  -- exit insert mode
  --
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'exit insert mode in terminal' })
  vim.keymap.set({ 'i', 't' }, 'jk', '<C-\\><C-n>', { desc = 'exit insert mode in terminal' })
end

function M.setup_navigation_keybind()
  -- Keybinds to make split navigation easier.
  vim.keymap.set({ 'n', 'i', 't' }, '<A-h>', '<C-\\><C-N><C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set({ 'n', 'i', 't' }, '<A-l>', '<C-\\><C-N><C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set({ 'n', 'i', 't' }, '<A-j>', '<C-\\><C-N><C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set({ 'n', 'i', 't' }, '<A-k>', '<C-\\><C-N><C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Move Tabs
end

function M.setup_resize_keybind()
  -- Keybinds to increase\decrease windowsize
  vim.keymap.set({ 'n', 'i', 't' }, '<A-S-l>', [[<cmd>vertical resize +5<cr>]])
  vim.keymap.set({ 'n', 'i', 't' }, '<A-S-h>', [[<cmd>vertical resize -5<cr>]])
  vim.keymap.set({ 'n', 'i', 't' }, '<A-S-j>', [[<cmd>horizontal resize +2<cr>]])
  vim.keymap.set({ 'n', 'i', 't' }, '<A-S-k>', [[<cmd>horizontal resize -2<cr>]])
end

function M.setup_fix_list_navigation_keybind()
  local current_mode = NAVIGATION_TAPS_MODE
  local function call_cmd(cmd)
    vim.cmd(cmd)
  end
  -- Switch navigation modes
  vim.keymap.set('n', 'ml', function()
    if current_mode ~= NAVIGATION_LOC_LIST_MODE then
      print('set navigation to ' .. MODE_NAMES[NAVIGATION_LOC_LIST_MODE] .. ' mode')
    end
    current_mode = NAVIGATION_LOC_LIST_MODE
  end, { desc = '' })

  vim.keymap.set('n', 'mq', function()
    if current_mode ~= NAVIGATION_QUICK_LIST_MODE then
      print('set navigation to ' .. MODE_NAMES[NAVIGATION_QUICK_LIST_MODE] .. ' mode')
    end
    current_mode = NAVIGATION_QUICK_LIST_MODE
  end, { desc = '' })

  vim.keymap.set('n', 'mt', function()
    if current_mode ~= NAVIGATION_TAPS_MODE then
      print('set navigation to ' .. MODE_NAMES[NAVIGATION_TAPS_MODE] .. ' mode')
    end
    current_mode = NAVIGATION_TAPS_MODE
  end, { desc = '' })

  -- HJKL mapping
  -- ***
  local h_map = { 'tabprevious', 'lpfile', 'cpfile' }
  vim.keymap.set('n', '<C-A-h>', function()
    pcall(call_cmd, h_map[current_mode])
  end, { desc = '' })
  -- **
  local l_map = { 'tabnext', 'lnfile', 'cnfile' }
  vim.keymap.set('n', '<C-A-l>', function()
    pcall(call_cmd, l_map[current_mode])
  end, { desc = '' })
  -- **
  local k_map = { 'tabfirst', 'labove', 'cabove' }
  vim.keymap.set('n', '<C-A-k>', function()
    pcall(call_cmd, k_map[current_mode])
  end, { desc = '' })
  -- **
  local j_map = { 'tablast', 'lbelow', 'cbelow' }
  vim.keymap.set('n', '<C-A-j>', function()
    pcall(call_cmd, j_map[current_mode])
  end, { desc = '' })
  -- quick fix: navigation
  -- vim.keymap.set('n', '<A-1>', '<cmd>cprevious<cr>', { desc = 'Move to previous Quick Fix' })
  -- vim.keymap.set('n', '<A-2>', '<cmd>cnext<cr>', { desc = 'Move to next Quick Fix' })

  -- vim.keymap.set('n', '<C-A-p>', '<cmd>lprevious<cr>', { desc = 'Move to previous loclist' })
  -- vim.keymap.set('n', '<C-A-n>', '<cmd>lnext<cr>', { desc = 'Move to next loclist' })
  -- vim.keymap.set('n', '<C-A-,>', '<cmd>labove<cr>', { desc = 'Move to previous loclist' })
  -- vim.keymap.set('n', '<C-A-m>', '<cmd>lbelow<cr>', { desc = 'Move to next loclist' })
  -- vim.keymap.set('n', '<C-A-n>', '<cmd>lbfile<cr>', { desc = 'Move to previous loclist' })
  -- vim.keymap.set('n', '<C-A-l>', '<cmd>lnfile<cr>', { desc = 'Move to next loclist' })
end

function M.setup_fix_list_toggle_keybind()
  vim.keymap.set('n', '<leader>lt', function()
    local win = vim.api.nvim_get_current_win()
    local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
    local action = qf_winid > 0 and 'lclose' or 'lopen'
    vim.cmd('botright ' .. action)
  end, { desc = '[L]location List [T]oggle' })

  vim.keymap.set('n', '<leader>qt', function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and 'cclose' or 'copen'
    vim.cmd('botright ' .. action)
  end, { desc = '[Q]uickFix list [T]oggle' })
end

function M.setup_fix_list_diagnostic_keybind()
  actions = require('telescope.actions')
  action_state = require('telescope.actions.state')
  builtin = require('telescope.builtin')
  local sources = { 'A', 'E', 'W', 'I', 'N' }
  local source_names = {
    A = '[A]ll',
    E = '[E]rror',
    W = '[W]arning',
    I = '[I]nfo',
    N = 'Hi[N]t',
    a = 'cbufr [A]ll',
    e = 'cbufr [E]rror',
    w = 'cbufr [W]arning',
    i = 'cbufr [I]nfo',
    n = 'cbufr Hi[N]t',
  }
  local signs = { '+', '-' }
  local sign_names = {
    ['+'] = '[+] min ==',
    ['-'] = '[-] max ==',
  }
  local modes = { 'a', 'r' }
  local mode_keys = { a = 'a', r = 's' }
  local mode_names = { a = '[A]ppend', r = '[S]et' }
  local dests = { 'l', 'c' }
  local dest_keys = { l = 'l', c = 'q' }
  local dest_names = { l = '[L]ocation list:', c = '[Q]uickFix list:' }
  local dest_short_names = { l = '[L]oclist:', c = '[Q]uickList:' }

  local which_key = require('which-key')

  for _, dest in ipairs(dests) do
    local dkey = dest_keys[dest]
    local dname = dest_names[dest]
    local dname_sh = dest_short_names[dest]
    for _, mode in ipairs(modes) do
      local mkey = mode_keys[mode]
      local mname = mode_names[mode]

      which_key.add({
        { '<leader>' .. dkey .. mkey, group = dname .. ' ' .. mname .. ' =>', mode = { 'n', 'x' } },
        { '<leader>' .. dkey .. mkey .. '/', group = dname .. ' ' .. mname .. ' Grep  =>', mode = { 'n', 'x' } },
        { '<leader>' .. dkey .. mkey .. '+', group = dname_sh .. ' ' .. mname .. ' [+] min == ...', mode = { 'n', 'x' } },
        { '<leader>' .. dkey .. mkey .. '-', group = dname_sh .. ' ' .. mname .. ' [+] max == ...', mode = { 'n', 'x' } },
      })

      vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. '/' .. 'g', function()
        M.grep_pattern(mode, dest, false)
      end, { desc = dname_sh .. ' ' .. mname .. ' [G]rep cbufr' })

      vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. '/' .. 'G', function()
        M.grep_pattern(mode, dest, true)
      end, { desc = dname_sh .. ' ' .. mname .. ' [G]rep all' })

      vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. '/' .. 'r', function()
        M.find_refrence(mode, dest)
      end, { desc = dname_sh .. ' ' .. mname .. 'find [R]eferences' })

      vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. '.', function()
        Utils.add_diagnostics_to_list(mode, dest, 'cursor', nil)
      end, { desc = dname_sh .. ' ' .. mname .. ' [C]urrent Line' })

      for _, src in ipairs(sources) do
        local src_lower = src:lower()
        vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. src, function()
          Utils.add_diagnostics_to_list(mode, dest, nil, src)
        end, { desc = dname_sh .. ' ' .. mname .. ' ' .. source_names[src] })
        vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. src_lower, function()
          Utils.add_diagnostics_to_list(mode, dest, 0, src)
        end, { desc = dname_sh .. ' ' .. mname .. ' ' .. source_names[src_lower] })

        for _, sgn in ipairs(signs) do
          if src ~= 'A' then
            vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. sgn .. src, function()
              Utils.add_diagnostics_to_list(mode, dest, nil, src .. sgn)
            end, { desc = dname_sh .. ' ' .. mname .. ' ' .. sign_names[sgn] .. ' ' .. source_names[src] })
            vim.keymap.set({ 'n', 'x' }, '<leader>' .. dkey .. mkey .. sgn .. src_lower, function()
              Utils.add_diagnostics_to_list(mode, dest, 0, src .. sgn)
            end, { desc = dname_sh .. ' ' .. mname .. ' ' .. sign_names[sgn] .. ' ' .. source_names[src_lower] })
          end
        end
      end
    end
  end
end

-- In lua/keys.lua

--- Convert a raw Telescope entry into a DiagnosticItem
--- so we can reuse util.reduce_/sort_/show_diagnostics_list
local function to_diagnostic_item(e)
  local filename = e.filename or (e.bufnr and vim.api.nvim_buf_get_name(e.bufnr))
  -- convert filename (not URI) into a buffer number; load buffer if needed
  local bufnr = e.bufnr or vim.fn.bufnr(filename, true)

  return {
    bufnr = bufnr,
    filename = filename,
    lnum = (e.lnum or (e.range and e.range.start.line)) + 1,
    col = (e.col or (e.range and e.range.start.character)) + 1,
    text = e.ordinal or e.display or e.text or '',
    type = 'N', -- just “note” for grep/refs
  }
end

--- Shared inner: collect multi‑selection or all results
local function collect_entries(picker, prompt_bufnr)
  local sels = picker:get_multi_selection()
  if #sels > 0 then
    return vim.tbl_map(to_diagnostic_item, sels)
  end
  local all = {}
  for e in picker.manager:iter() do
    table.insert(all, to_diagnostic_item(e))
  end
  return all
end

function M.grep_pattern(mode, dest, all)
  local finder = all and builtin.live_grep or builtin.current_buffer_fuzzy_find
  finder({
    attach_mappings = function(prompt_bufnr, map)
      local picker = action_state.get_current_picker(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        -- **REUSE** the filtering/sorting/display logic:
        local items = collect_entries(picker, prompt_bufnr)
        Utils.show_diagnostics_list(mode, dest, items, 'Grep Results')
      end)
      return true
    end,
  })
end

function M.find_refrence(mode, dest)
  builtin.lsp_references({
    attach_mappings = function(prompt_bufnr, map)
      local picker = action_state.get_current_picker(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local items = collect_entries(picker, prompt_bufnr)
        Utils.show_diagnostics_list(mode, dest, items, 'LSP References')
      end)
      return true
    end,
  })
end

---@param mode 'a'|'r'  -- append or replace
---@param dest  'l'|'c'  -- loclist or quickfix
---@param all boolean  -- all or current buffer
--function M.grep_cbufr(mode, dest, all)
--   --TODO: implement this function , it should open a telescope window for searching up patterns in current/all files
--   -- if user press enter and no selections made ( by pressing tab) then all current search result should be appended/replaced to the dest list
--   -- if user press enter and some selections made ( by pressing tab) then only selected items should be appended/replaced to the dest list
-- end

---@param mode 'a'|'r'  -- append or replace
---@param dest  'l'|'c'  -- loclist or quickfix
-- function M.find_refrence(mode, dest)
--   --TODO: implement this function , it should open a telescope window for searching up patterns in all lsp.refrence for current cursor location .
--   -- if user press enter and no selections made ( by pressing tab) then all current search result should be appended/replaced to the dest list
--   -- if user press enter and some selections made ( by pressing tab) then only selected items should be appended/replaced to the dest list
-- end

function M.setup_arabic_keybind()
  vim.keymap.set({ 'n' }, 'arb', Utils.setup_arabic, { desc = 'Enable Arabic mode' })
  vim.keymap.set({ 'n' }, 'eng', Utils.setup_latin, { desc = 'Disable Arabic mode' })
end

function M.set_yz_keybind()
  vim.keymap.set('i', '<C-z>', '<C-y>')
end

function M.setup_telescope_keybind()
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = '[/] Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep({
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    })
  end, { desc = '[S]earch [/] in Open Files' })
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files({ cwd = vim.fn.stdpath('config') })
  end, { desc = '[S]earch [N]eovim files' })
end

function M.setup_buffer_specific_telescope_keybind(buf)
  local builtin = require('telescope.builtin')
  M.map('gO', builtin.lsp_document_symbols, 'Open Document Symbols', buf)
  M.map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols', buf)
  M.map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition', buf)
  M.map('grr', builtin.lsp_references, '[G]oto [R]eferences', buf)
  M.map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation', buf)
  M.map('grd', builtin.lsp_definitions, '[G]oto [D]efinition', buf)
end

function M.setup_buffer_specific_lsp_keybind(buf)
  M.map('grn', vim.lsp.buf.rename, '[R]e[n]ame', buf)
  M.map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', buf, { 'n', 'x' })
  M.map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', buf)
  vim.keymap.set('n', 'gK', function()
    local is_visible = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
      virtual_lines = (not is_visible and { current_line = true } or false),
    })
    -- vim.diagnostic.show(nil, 0)
  end, { desc = 'Toggle diagnostic virtual_lines' })
end

function M.setup_buffer_specific_inlayhints_keybind(buf)
  M.map('<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
  end, '[T]oggle Inlay [H]ints')
end
function M.map(keys, func, desc, buf, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
end

return M

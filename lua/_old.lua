local M = {}

---@deprecated
M.ensure_installed_ls = {
  'rust_analyzer',
  'pyright',
  'clangd',
  'ts_ls',
  'neocmakelsp',
  'html',
  'cssls',
  'tailwindcss',
  -- styling
  'stylua',
  'black',
  'eslint',
  'prettier',
  'emmet-language-server',
}

---@deprecated
function M.configure_an_lsp_server(server_name)
  local default_config = (lspConfig[server_name] or {}).default_config or {}
  local user_config = vim.lsp.config[server_name] or {}
  vim.lsp.config(server_name, vim.tbl_extend('force', default_config, user_config))
end

---@deprecated
function M.get_already_installed_ls()
  local req = require('mason-registry')
  return req.get_installed_package_names()
end

---@deprecated dont use this
function M.configure_ls_run_command()
  local mlsp = require('mason-lspconfig')
  local cmd_mapping = mlsp.get_mappings()
  local already_installed = M.get_already_installed_ls()
  for _, server in ipairs(already_installed) do
    vim.lsp.config(server, {
      cmd = server,
    })
  end
  for _, server in ipairs(M.ensure_installed_ls) do
    if not vim.tbl_contains(already_installed, server) then
      vim.lsp.config(server, {
        cmd = cmd_mapping.lspconfig_to_mason[server] or server,
      })
    end
  end
end

function M.add_all_diagnostics(model, dest)
  local diagnostics = vim.diagnostic.get() -- {}
  vim.fn.setqflist({}, 'r', { items = vim.diagnostic.toqflist(diagnostics), title = 'All Diagnostics' })
  vim.cmd('copen')
end

---@deprecated dont use this
---@param list_type "clist"|"llist"
function M.add_current_line_to_list(list_type)
  local line = vim.api.nvim_win_get_cursor(0)
  local line_text = vim.api.nvim_get_current_line()
  line_text = M.trim_string(line_text, 10)
  local bufn = vim.api.nvim_get_current_buf()

  local file_name = vim.api.nvim_buf_get_name(bufn) --vim.api.nvim_get_option_value('filename', { buf = bufn })

  ---@type DiagnosticItem
  local entry = { bufnr = bufn, filename = file_name, lnum = line[1], col = line[2], text = line_text, type = 'c' }
  if list_type == 'clist' then
    vim.fn.setqflist({
      entry,
    }, 'a')
  elseif list_type == 'llist' then
    vim.fn.setloclist(0, {
      entry,
    }, 'a')
  end
end

---WARN:  function to toggle explorer/terminal , not finish yet , no need for it now ..!!

---@deprecated dont use this
---@param target "tree"|"terminal"
function M.toggler(target)
  if target or not target then
    return
  end

  local visible_windows = vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
  local total_win_count = #visible_windows
  local tree_win_count = 0
  local terminal_win_count = 0
  local neotree = require('neo-tree.command')
  for id, win_value in ipairs(visible_windows) do
    local buf = vim.api.nvim_win_get_buf(win_value)
    local file_type = vim.api.nvim_get_option_value('filetype', { buf = buf })
    local buf_type = vim.api.nvim_get_option_value('buftype', { buf = buf })
    if file_type == 'netrw' then
      vim.api.nvim_win_hide(win_value)
      tree_win_count = tree_win_count + 1
    elseif file_type == 'neo-tree' then
      vim.api.nvim_set_current_win(win_value)
      neotree.execute({ action = 'close', position = 'current' })
    elseif buf_type == 'terminal' then
      vim.api.nvim_win_hide(win_value)
      terminal_win_count = terminal_win_count + 1
    end
  end

  if total_win_count == 1 and tree_win_count + terminal_win_count == 1 then
    print('closing Explorer')

    vim.api.nvim_exec(':Vexplore ', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>H', true, true, true), 'n', true)
  end

  if tree_win_count == 0 or total_win_count == 1 then
    print('trying to reopen Explorer')
    vim.api.nvim_exec(':Vexplore ', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>H', true, true, true), 'n', true)
  end
end
---@deprecated
function M.setup()
  -- default configs for all language-servers :
  vim.lsp.config('*', {
    root_markers = { '.git' },
  })

  -- configure the cammand to run  each language-server
  -- M.configure_ls_run_command()
end

return {}

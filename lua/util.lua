local M = {}

---@class DiagnosticItem
---@field bufnr integer
---@field filename string
---@field lnum integer
---@field col integer
---@field text string
---@field type "E" | "W" | "I" | "N" | "c"
---@field userdata? any

--- Gather diagnostics from buffer or cursor
---@param src integer|nil|"cursor"
---@param severity string|nil -- e.g. 'A','E+','W-'
---@return DiagnosticItem[]
function M.get_diagnostics(src, severity)
  local diags = {}

  if src == nil or type(src) == 'number' then
    -- filter by severity
    severity = (severity == nil or severity == '') and 'A' or severity
    local base = severity:sub(1, 1):upper()
    local sev = vim.diagnostic.severity[base]
    local opts = {}
    local sign = severity:sub(2, 2)
    if sign == '+' then
      opts = { severity = { min = sev } }
    elseif sign == '-' then
      opts = { severity = { max = sev } }
    else
      opts = { severity = sev }
    end

    local raw = vim.diagnostic.get(src, opts)
    diags = vim.diagnostic.toqflist(raw)
  else
    -- single‐cursor entry
    local pos = vim.api.nvim_win_get_cursor(0)
    local text = vim.api.nvim_get_current_line()
    text = M.trim_string(text, pos[2], 20)
    local bufn = vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(bufn)
    table.insert(diags, {
      bufnr = bufn,
      filename = fname,
      lnum = pos[1],
      col = pos[2],
      text = text,
      type = 'c',
    })
  end

  return diags
end

--------------------------------------------------------------------------------
-- Part 2: filter, sort and display any list of DiagnosticItem
--------------------------------------------------------------------------------

--- Reduce, sort and send a list of DiagnosticItem to loclist or quickfix
---@param mode "r"|"a"        -- replace or append
---@param dest "c"|"l"        -- quickfix or loclist
---@param items DiagnosticItem[]  -- raw entries
---@param title string|nil     -- window title (only used on 'r')
function M.show_diagnostics_list(mode, dest, items, title)
  -- append existing if requested
  if mode == 'a' then
    local existing = (dest == 'l') and vim.fn.getloclist(0) or vim.fn.getqflist()
    vim.list_extend(items, existing)
  end

  -- reuse existing reduction & sorting
  items = M.reduce_diagnostics(items)
  M.sort_diagnostics(items)

  -- set the list
  local args = { items = items }
  if mode == 'r' and title then
    args.title = title
  end

  if dest == 'l' then
    vim.fn.setloclist(0, {}, mode, args)
    vim.cmd('lopen')
  else
    vim.fn.setqflist({}, mode, args)
    vim.cmd('copen')
  end
end

--------------------------------------------------------------------------------
-- Legacy wrapper combining both parts
--------------------------------------------------------------------------------

--- Populate diagnostics into quickfix/loclist
---@param mode "r"|"a"
---@param dest "c"|"l"
---@param src integer|nil|"cursor"
---@param severity string|nil
function M.add_diagnostics_to_list(mode, dest, src, severity)
  local items = M.get_diagnostics(src, severity)
  local title = (mode == 'r') and (src == nil and 'All Diagnostics' or 'Buffer Diagnostics') or nil
  M.show_diagnostics_list(mode, dest, items, title)
end

-- ---@param mode "r"|"a"
-- ---@param dest "c"|"l"
-- ---@param src integer|nil|"cursor"
-- ---@param severity string|nil -- 'A'|'E+'|'W+'|'I+'|'H+'|'E-' |'W-'|'I-'|'H-'
-- function M.add_diagnostics_to_list(mode, dest, src, severity)
--   -- print('recieved Severity : ' .. severity)
--   local diagnostics = {}
--   if src == nil or type(src) == 'number' then
--     if severity == nil or severity == '' then
--       severity = 'A'
--     end
--     local sev_type = severity:sub(1, 1)
--     sev_type = vim.diagnostic.severity[sev_type:upper()]
--     local getOpt = nil
--     if sev_type ~= nil then
--       getOpt = {}
--       local sev_sign = severity:sub(2, 2)
--       if sev_sign == '+' then
--         getOpt = { severity = { min = sev_type } }
--       elseif sev_sign == '-' then
--         getOpt = { severity = { max = sev_type } }
--       else
--         getOpt = { severity = sev_type }
--       end
--     end
--     diagnostics = vim.diagnostic.toqflist(vim.diagnostic.get(src, getOpt))
--   else
--     local line = vim.api.nvim_win_get_cursor(0)
--     local line_text = vim.api.nvim_get_current_line()
--     line_text = M.trim_string(line_text, line[2], 20)
--     local bufn = vim.api.nvim_get_current_buf()
--     local file_name = vim.api.nvim_buf_get_name(bufn)
--     ---@type DiagnosticItem
--     local entry = { bufnr = bufn, filename = file_name, lnum = line[1], col = line[2], text = line_text, type = 'c' }
--     diagnostics = { entry }
--   end
--
--   if mode == 'a' then
--     vim.list_extend(diagnostics, dest == 'l' and vim.fn.getloclist(0) or vim.fn.getqflist())
--   end
--   diagnostics = M.reduce_diagnostics(diagnostics)
--   M.sort_diagnostics(diagnostics)
--
--   local title = nil
--   if mode == 'r' then
--     title = src == nil and 'All Diagnostics' or 'Buffer Diagnostics'
--   end
--
--   if dest == 'l' then
--     vim.fn.setloclist(0, {}, 'r', { items = diagnostics, title = title })
--   else
--     vim.fn.setqflist({}, 'r', { items = diagnostics, title = title })
--   end
--   vim.cmd(dest == 'l' and 'lopen' or 'copen')
-- end

---@param str string
---@param span? integer
---@param col integer
function M.trim_string(str, col, span)
  span = span or 10
  local start = col - span
  start = start < 1 and 1 or start
  local ends = col + span
  ends = ends > #str and #str or ends
  return str:sub(start, ends)
end

function M.setup_arabic()
  vim.o.arabic = true
  vim.cmd('set keymap=arabic-german_utf-8')
  if vim.g.neovide then
    vim.o.guifont = 'DejaVu Sans Mono'
  end
  print('Arabic mode enabled')
end

function M.setup_latin()
  vim.o.arabic = false
  vim.cmd('set keymap=')
  if vim.g.neovide then
    vim.o.guifont = ''
  end
  print('Arabic mode disabled')
end

---@type fun(diagnostics : DiagnosticItem[]):nil
function M.sort_diagnostics(diagnostics)
  if #diagnostics == 0 then
    return
  end

  table.sort(
    diagnostics,

    ---@type fun(a: DiagnosticItem, b: DiagnosticItem):boolean
    function(a, b)
      -- a.filename = a.filename == nil and vim.api.nvim_buf_get_name(a.bufnr) or a.filename
      -- b.filename = b.filename == nil and vim.api.nvim_buf_get_name(b.bufnr) or b.filename

      if a.filename ~= b.filename then
        return a.filename > b.filename
      end

      -- local sev_a = vim.diagnostic.severity[a.type:upper()]
      -- local sev_b = vim.diagnostic.severity[b.type:upper()]
      --
      -- if sev_a ~= nil and sev_b ~= nil and sev_a ~= sev_b then
      --   return sev_a < sev_b
      -- end

      if a.lnum ~= b.lnum then
        return a.lnum < b.lnum
      end
      if a.col ~= b.col then
        return a.col < b.col
      end
      return false
    end
  )
end

---@type fun(diagnostics : DiagnosticItem[]):nil
---@return DiagnosticItem[]
function M.reduce_diagnostics(diagnostics)
  local result = vim
    .iter(diagnostics)
    :map(
      ---@param a DiagnosticItem
      ---@return DiagnosticItem
      function(a)
        a.filename = a.filename == nil and vim.api.nvim_buf_get_name(a.bufnr) or a.filename
        return a
      end
    )
    :fold(
      {},
      ---@param item DiagnosticItem
      ---@param acc table<string, DiagnosticItem>
      function(acc, item)
        item.col = item.col or 0
        local col = ' ' .. item.col
        local is_custom = item.type == 'c'
        local key = item.filename .. ':' .. item.lnum .. ':' .. item.type

        local prefix = '[col' .. col .. '] '
        if is_custom or item.text:find('%[col') then
          prefix = ''
        end
        if not acc[key] then
          acc[key] = item
          acc[key].text = prefix .. item.text
        elseif not is_custom then
          local sub = item.text:gsub('%[col %d+%]%s*', '', 1)
          print('original: ', item.text)
          print('sub: ', sub)
          local is_new = not acc[key].text:find(sub)
          if is_new then
            acc[key].text = acc[key].text .. ', ' .. prefix .. item.text
          end
        end
        return acc
      end
    )
  -- print(vim.inspect(result))
  return vim.tbl_values(result)
end

return M

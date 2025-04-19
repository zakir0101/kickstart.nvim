--WARN: this was only for TESTING and LEARNING purpos
--************************************************
--
--
-- NOTE: do not modify any of the following code , all has been successfully tested and working , just write code in poistion with `TODOs`
-- this note is for LLM

local api = vim.api
local uv = vim.loop
local M = {}

-- Global state for AI chat
local state = {
  project_dir = vim.fn.getcwd(),
  genai_dir = nil,
  prompt_path = nil,
  current_chat_file = nil,
  current_model = 'default-model',
  chat_win = nil,
  input_win = nil,
  chat_buf = nil,
  input_buf = nil,
  floating_window = false,
}

--
-- ##SECTION:
-- **************************************************************
-- ***************** Utility Functions **************************
-- **************************************************************
--
--
local function sleep(n)
  if n > 0 then
    os.execute('ping -n ' .. tonumber(n + 1) .. ' localhost > NUL')
  end
end
-- Utility: Ensure directory exists
local function ensure_dir(dir)
  if not uv.fs_stat(dir) then
    uv.fs_mkdir(dir, 493) -- 0755 in decimal
  end
end

-- Utility: Ensure file exists (create if not exist)
local function ensure_file(file)
  local f = io.open(file, 'a')
  if f then
    f:close()
  end
end

local function get_last_index()
  local handle = uv.fs_scandir(state.genai_dir)
  max = 0
  while true do
    local name, typ = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local match = string.find(name, 'chat_(%d+).md')
    if match then
      local num = string.gmatch(name, '%d+')()
      num = tonumber(num)
      -- print(num)
      if num > max then
        max = num
      end
    end
  end

  -- print('last max', max)
  return tostring(max + 1)
end

-- Check if AI chat interface is active
local function has_open_chat_win()
  local chat_opened = state.chat_win and api.nvim_win_is_valid(state.chat_win)
  return chat_opened
end

local function has_open_input_win()
  local input_opened = state.input_win and api.nvim_win_is_valid(state.input_win)
  return input_opened
end
local function has_input_buffer()
  local input_buf_created = state.input_buf and api.nvim_buf_is_valid(state.input_buf)
  return input_buf_created
end

local function has_chat_buffer()
  local chat_buf_created = state.chat_buf and api.nvim_buf_is_valid(state.chat_buf)
  return chat_buf_created
end

-- Clear prompt.md for next query
local function save_prompt_file()
  if has_open_input_win() then
    api.nvim_set_current_win(state.input_win)
    vim.cmd.write({ state.prompt_path, bang = true })
    return true
  else
    return false
  end
end

local function save_chat_file()
  if has_open_chat_win() then
    api.nvim_set_current_win(state.chat_win)
    vim.cmd.write({ state.current_chat_file, bang = true })
    return true
  else
    return false
  end
end

local function read_file(file_path)
  local file = io.open(file_path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*a')
  file:close()
  return content
end

--
-- ##SECTION:
-- **************************************************************
-- ***************** Logic Functions ****************************
-- **************************************************************
--
--

-- Initialize .genai directory and prompt file if needed
local function init_genai()
  state.genai_dir = state.project_dir .. '\\.genai'
  state.prompt_path = state.genai_dir .. '\\prompt.md'
  state.current_chat_file = state.genai_dir .. '\\chat_' .. get_last_index() .. '.md'
  ensure_dir(state.genai_dir)
end
-- If windows are active and valid, hide them without closing buffers and return
local function close_windows()
  local is_open = false
  if has_open_chat_win() then
    api.nvim_win_close(state.chat_win, false)
    is_open = true
  end
  if has_open_input_win() then
    api.nvim_win_close(state.input_win, false)
    is_open = true
  end
  return is_open
end

-- Create buffers if they don't exist
local function create_buffer_if_not_exist()
  local scratch = false
  local listed = false

  if not (has_input_buffer()) then
    local prev_prompt = read_file(state.prompt_path)
    state.input_buf = api.nvim_create_buf(listed, scratch)
    api.nvim_buf_set_name(state.input_buf, state.prompt_path)
    if prev_prompt then
      save_prompt_file()
    end
  end

  if not (has_chat_buffer()) then
    state.chat_buf = api.nvim_create_buf(listed, scratch)
    api.nvim_buf_set_option(state.chat_buf, 'modifiable', false)
    -- api.nvim_buf_set_option(state.chat_buf, 'readonly', true)
    api.nvim_buf_set_name(state.chat_buf, state.current_chat_file)
  end
end

-- Create windows for AI chat interface
local function create_windows()
  local width = 80
  local margin = 2
  local available_height = vim.o.lines - margin
  local chat_height = math.floor(available_height * 0.7)
  local input_height = available_height - chat_height

  -- after splitting the focus move to th new window, so we resize the newly created input window
  vim.cmd('vertical botright split')
  state.chat_win = api.nvim_get_current_win()
  -- local scope
  vim.cmd('vertical resize ' .. width)
  vim.cmd('split')
  state.input_win = api.nvim_get_current_win()
  vim.cmd('resize ' .. input_height)
end

local function create_floating_windows()
  local width = 80
  local margin = 2
  local available_height = vim.o.lines - margin
  local chat_height = math.floor(available_height * 0.7)
  local input_height = available_height - chat_height

  local total_height = chat_height + input_height

  vim.cmd('highlight UserInputBorder guifg=#FF0000')
  vim.cmd('highlight AIChatBorder guifg=#00FF00')

  local col = vim.o.columns - width

  local row_chat = vim.o.lines - total_height - 1
  local row_input = row_chat + chat_height

  state.chat_win = api.nvim_open_win(state.chat_buf, false, {
    relative = 'editor',
    width = width,
    height = chat_height,
    col = col,
    row = row_chat,
    border = 'single', -- Simple border style
    title = ' AI Chat ', -- Title for the border
    title_pos = 'center', -- Center the title
    style = 'minimal',
  })

  vim.api.nvim_set_option_value('winhl', 'FloatBorder:AIChatBorder', { win = chat_win })

  state.input_win = api.nvim_open_win(state.input_buf, true, {
    relative = 'editor',
    width = width,
    height = input_height,
    col = col,
    row = row_input,
    border = 'single',
    title = ' User Input ',
    title_pos = 'center',
    style = 'minimal',
  })

  vim.api.nvim_set_option_value('winhl', 'FloatBorder:UserInputBorder', { win = input_win })
end

-- Set buffers for windows
local function attach_buffers_to_windows()
  if has_input_buffer() then
    api.nvim_win_set_buf(state.input_win, state.input_buf)
  end
  if has_chat_buffer() then
    api.nvim_win_set_buf(state.chat_win, state.chat_buf)
    api.nvim_set_option_value('winfixbuf', true, { win = state.chat_win, scope = 'local' })
  end
end

local function stream_response()
  api.nvim_buf_set_option(state.chat_buf, 'modifiable', true)

  local model_tag = '<<ai [' .. state.current_model .. ']>>'
  local msg = { model_tag }
  api.nvim_buf_set_lines(state.chat_buf, -1, -1, false, msg)

  local ai_response = 'This is a mock response from ' .. state.current_model
  for _ = 0, 5 do
    local paragraph = ''
    api.nvim_buf_set_lines(state.chat_buf, -1, -1, false, { '', '' })
    for _ = 0, 6 do
      paragraph = paragraph .. ai_response
      api.nvim_buf_set_lines(state.chat_buf, -2, -1, false, { paragraph })
    end
  end
  api.nvim_buf_set_lines(state.chat_buf, -1, -1, false, { '' })

  api.nvim_buf_set_option(state.chat_buf, 'modifiable', false)
end

local function append_user_input_to_chat(input_lines)
  api.nvim_buf_set_option(state.chat_buf, 'modifiable', true)

  local current_lines = {}
  local user_tag = '<<user>>'
  table.insert(current_lines, user_tag)
  table.insert(current_lines, '')
  for _, v in pairs(input_lines) do
    table.insert(current_lines, v)
  end

  table.insert(current_lines, '')
  table.insert(current_lines, '')

  api.nvim_buf_set_lines(state.chat_buf, -1, -1, false, current_lines)

  api.nvim_buf_set_option(state.chat_buf, 'modifiable', false)
end
--
-- ##SECTION:
-- **************************************************************
-- ***************** Public Functions ***************************
-- **************************************************************
--
--

-- Toggle AI Chat interface
function M.toggle_ai_chat()
  if not state.genai_dir then
    init_genai()
  end
  if close_windows() then
    return
  end

  create_buffer_if_not_exist()
  if state.floating_window then
    create_floating_windows()
  else
    create_windows()
  end
  attach_buffers_to_windows()
  if vim.fn.filereadable(state.prompt_path) == 0 then
    save_prompt_file()
  else
    api.nvim_set_current_win(state.input_win)
  end
  vim.cmd('startinsert')
end

-- Mock function to send prompt and stream response
function M.send_prompt()
  if (not has_open_input_win()) or (not has_open_chat_win()) then
    close_windows()
    print('AI Chat interface opened. Please send your prompt again.')
    return
  end

  -- Get user input
  local input_lines = api.nvim_buf_get_lines(state.input_buf, 0, -1, false)
  local user_input = table.concat(input_lines, '\n')

  if not string.find(user_input, '%w+') then
    print('No input provided.')
    return
  end

  -- Clear the input buffer
  api.nvim_buf_set_lines(state.input_buf, 0, -1, false, {})
  save_prompt_file()

  -- Temporarily allow modifiability

  append_user_input_to_chat(input_lines)

  local num_lines = api.nvim_buf_line_count(state.chat_buf)
  api.nvim_win_set_cursor(state.chat_win, { num_lines, 0 })
  api.nvim_set_current_win(state.chat_win)

  local timer = uv.new_timer()
  timer:start(
    0,
    0,
    vim.schedule_wrap(function()
      stream_response()
    end)
  )

  api.nvim_buf_set_option(state.chat_buf, 'modifiable', false)

  -- Append AI response to conversation file
  save_chat_file()
end

function M.set_floating_window(floating)
  state.floating_window = floating

  if (has_open_input_win()) or (has_open_chat_win()) then
    close_windows()
    M.toggle_ai_chat()
    return
  end
end
--
--              **********************************
-- ********************** Key mappings **************************
--              **********************************
--

-- vim.keymap.set('n', '<leader>gt', M.toggle_ai_chat, { desc = '[G]enerative AI [T]oggle' })
-- vim.keymap.set('n', '<leader>gs', M.send_prompt, { desc = '[G]enerative AI [S]end' })

--
-- ##SECTION:
-- **************************************************************
-- ***************** TODOS: *************************************
-- **************************************************************
--
--

--NOTE: from here you can modify the code below and complete the TODOs

--TODO: 1. define a command ( :command ) or an option ( :set opt )j the user of this plugin can utilze to set the value of state.floating_window ( do NOT use a keyboard shortcut !! )
-- code here ....

--TODO: 2. create a function "open_chat(chat_file_name)" which load a selected chat and set it as the current chat

vim.api.nvim_create_user_command('GenAISetFloating', function(opts)
  local arg = opts.args:lower()
  if arg == 'true' then
    M.set_floating_window(true)
    print('Floating window mode enabled.')
  elseif arg == 'false' then
    M.set_floating_window(false)
    print('Floating window mode disabled.')
  else
    print('Usage: GenAISetFloating <true|false>')
  end
end, {
  nargs = 1,
  desc = 'Set floating_window mode for Generative AI plugin',
})

function M.open_chat(chat_file_name)
  -- Construct full path to the chat file
  local full_path = state.genai_dir .. '\\' .. chat_file_name
  if not uv.fs_stat(full_path) then
    print('Chat file does not exist: ' .. full_path)
    return
  end

  -- Update current chat file in state
  state.current_chat_file = full_path

  -- Read the content of the chat file
  local content = read_file(full_path)
  if content then
    local lines = vim.split(content, '\n', true)

    -- Ensure chat buffer exists
    if not has_chat_buffer() then
      create_buffer_if_not_exist()
    end

    -- Load the content into the chat buffer
    api.nvim_buf_set_option(state.chat_buf, 'modifiable', true)
    api.nvim_buf_set_lines(state.chat_buf, 0, -1, false, lines)
    api.nvim_buf_set_option(state.chat_buf, 'modifiable', false)

    print('Loaded chat: ' .. chat_file_name)
  else
    print('Failed to read content from: ' .. full_path)
  end
end
return {}

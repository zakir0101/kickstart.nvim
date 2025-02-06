local api = vim.api

local function toggle_ai_chat()
  -- Define a fixed width for both windows
  local width = 80

  -- Calculate available height, leaving a small margin for statusline/command line, etc.
  local margin = 2
  local available_height = vim.o.lines - margin

  -- Allocate 80% of the height for the AI Chat and 20% for User Input
  local chat_height = math.floor(available_height * 0.8)
  local input_height = available_height - chat_height
  local total_height = chat_height + input_height
  -- Create two unlisted buffers (no listed in the buffer list)
  local chat_buf = api.nvim_create_buf(false, true)
  local input_buf = api.nvim_create_buf(false, true)

  -- Set up highlight groups for border colors
  vim.cmd 'highlight UserInputBorder guifg=#FF0000'
  vim.cmd 'highlight AIChatBorder guifg=#00FF00'

  -- Calculate the rightmost column position and vertical positions
  local col = vim.o.columns - width
  -- Place windows near the bottom right of the screen
  local row_chat = vim.o.lines - total_height - 1 -- Adjust for status/command lines if needed
  local row_input = row_chat + chat_height

  -- Open the AI Chat floating window at the top
  local chat_win = api.nvim_open_win(chat_buf, false, {
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
  -- Apply the custom border color for AI Chat
  -- api.nvim_win_set_option(chat_win, 'winhl', 'FloatBorder=AIChatBorder')
  vim.api.nvim_set_option_value('winhl', 'FloatBorder:AIChatBorder', { win = chat_win })

  -- Open the User Input floating window at the bottom
  local input_win = api.nvim_open_win(input_buf, true, {
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

  print('input_win' .. input_win)
  -- Apply the custom border color for User Input
  -- api.nvim_win_set_option(input_win, 'winhl', 'FloatBorder=UserInputBorder')
  vim.api.nvim_set_option_value('winhl', 'FloatBorder:UserInputBorder', { win = input_win })
  -- Set the AI Chat buffer as read-only and non-modifiable
  api.nvim_buf_set_option(chat_buf, 'modifiable', false)
  api.nvim_buf_set_option(chat_buf, 'readonly', true)

  -- Switch focus to the User Input window and enter insert mode
  api.nvim_set_current_win(input_win)
  vim.cmd 'startinsert'
end

-- vim.keymap.set('n', '<leader>gt', toggle_ai_chat, { desc = '[G]enerative AI [T]oggle' })

return {}

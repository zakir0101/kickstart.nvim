CopilotChatOptions = {

  model = 'gpt-4o',
  agent = 'copilot',
  context = nil, -- Default context or array of contexts to use (can be specified manually in prompt via #).
  temperature = 0.1,

  headless = false, -- Do not write to chat buffer and use history(useful for using callback for custom processing)
  callback = nil, -- Callback to use when ask response is received

  -- selection = function(source)
  --   return select.visual(source) or select.buffer(source)
  -- end,

  -- default window options
  window = {
    layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.5,
    height = 0.5,
    --  apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = 'Copilot Chat',
    footer = nil,
    zindex = 1,
  },

  show_help = true, -- Shows help message as virtual lines when waiting for user input
  show_folds = true, -- Shows folds for sections in chat
  highlight_selection = true, -- Highlight selection
  highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
  insert_at_end = false, -- Move cursor to end of buffer when inserting text
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

  -- Static config starts here (can be configured only via setup function)

  debug = false, -- Enable debug logging (same as 'log_level = 'debug')
  log_level = 'info', -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  proxy = nil, -- [protocol://]host[:port] Use this proxy
  allow_insecure = false, -- Allow insecure server connections

  chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
  history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history

  question_header = '## User ', -- Header to use for user questions
  answer_header = '## Copilot ', -- Header to use for AI answers
  error_header = '## Error ', -- Header to use for errors
  separator = '───', -- Separator to use in chat

  contexts = {},

  prompts = {},

  -- default mappings
  mappings = {
    complete = {
      insert = '<Tab>', -- <leader>gcc
    },
    close = {
      normal = '<A-q>',
      insert = '<A-q>',
    },
    reset = {
      normal = '<leader>ge',
      insert = '<leader>ge',
    },
    submit_prompt = {
      normal = 'gs',
      insert = 'gs',
    },
    toggle_sticky = {
      detail = 'Makes line under cursor sticky or deletes sticky line.',
      normal = 'gt',
    },
    accept_diff = {
      normal = 'ga',
      insert = 'ga',
    },
    jump_to_diff = {
      normal = 'gj',
    },
    quickfix_diffs = {
      normal = 'gq',
    },
    yank_diff = {
      normal = 'gy',
      register = '"',
    },
    show_diff = {
      normal = 'gf',
    },
    show_info = {
      normal = 'gi',
    },
    show_context = {
      normal = 'gc',
    },
    show_help = {
      normal = 'gh',
    },
  },
}

-- vim.g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']()
vim.api.nvim_create_autocmd('DirChanged', {
  pattern = '*',
  callback = function()
    vim.g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']()
  end,
})

local path = nil
if vim.fn.isdirectory('D:\\Projects\\CopilotChat.nvim') ~= 0 then
  path = 'D:\\Projects\\CopilotChat.nvim'
end
return {
  {
    -- hall zakir
    'github/copilot.vim',
    config = function()
      -- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
      --   expr = true,
      --   replace_keycodes = false
      -- })

      vim.keymap.set('i', '<C-A-L>', '<Plug>(copilot-accept-word)')
      vim.keymap.set('i', '<C-A-H>', '<Plug>(copilot-accept-line)')

      vim.keymap.set('i', '<C-A-J>', '<Plug>(copilot-next)')
      vim.keymap.set('i', '<C-A-K>', '<Plug>(copilot-previous)')
      vim.keymap.set('i', '<C-A-s>', '<Plug>(copilot-suggest)')
      vim.keymap.set('i', '<C-A-d>', '<Plug>(copilot-dismiss)')
      vim.keymap.set('i', '<A-a>', '<cmd>Copilot panel<cr>')

      -- vim.keymap.set('i', '<A-C-c>', '<cmd>Copilot panel<cr>')
      -- vim.keymap.set('i', '<leader-c>', '<cmd>Copilot panel<cr>', { desc = '[C]opilot panel' })

      vim.g.copilot_filetypes = {
        markdown = true,
      }

      -- <Plug>(copilot-accept-wordd
      -- <Plug>(copilot-accept-line)
      -- <Plug>(copilot-suggest)
      -- <Plug>(copilot-dismiss)
      -- <Plug>(copilot-next)
      -- <Plug>(copilot-previous)
    end,
  },

  {
    'zakir0101/CopilotChat.nvim',
    branch = not path('zakir') or nil,
    dir = path,

    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    -- build = 'make tiktoken', -- Only on MacOS or Linux
    config = function()
      local chat = require('CopilotChat')
      -- require("CopilotChat.select").bufferk
      chat.setup(CopilotChatOptions)
      vim.keymap.set('n', '<leader>gt', function()
        chat.toggle()
      end, { desc = '[G]enerative AI [T]oggle' })
      vim.keymap.set('n', '<leader>go', function()
        chat.open()
      end, { desc = '[G]enerative AI [O]pen' })
      vim.keymap.set('n', '<leader>gr', function()
        chat.reset()
      end, { desc = '[G]enerative AI [R]eset' })
      -- Remap default keybinding
      vim.keymap.set('n', '<leader>gs', 'gs', { desc = '[G]enerative AI [S]end' })
      -- vim.keymap.set('n', '<leader>gc', '<leader>gcc', { desc = '[G]enerative AI [C]omplete' })

      -- vim.keymap.set('n', '<leader>gq', '<leader>gcq', { desc = '[G]enerative AI [q]lose' })
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}

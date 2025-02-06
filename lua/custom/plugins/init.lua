-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

os.execute '. enter-vsshell.ps1'
local nvimrc = vim.fn.stdpath 'config'
-- vim.cmd('source ' .. nvimrc .. '\\lua\\custom\\plugins\\' .. 'autohotkey.vim')

-- PowerShell 7
--
--
os.execute '. pwsh -Command { $PSStyle.FileInfo.Directory = "`e[100;1m" } '
vim.o.shell = '"C:\\Program Files\\PowerShell\\7\\pwsh.exe"'
vim.o.shellcmdflag =
  '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command  [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellquote = ''
vim.o.shellxquote = ''

--
-- exit insert mode
--
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { desc = 'exit insert mode in terminal' })
vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', { desc = 'exit insert mode in terminal' })
vim.keymap.set('i', 'jk', '<C-\\><C-n>', { desc = 'exit insert mode in terminal' })

--
-- LSP Function signature
--
vim.keymap.set({ 'n' }, '<Leader>k', function()
  require('lsp_signature').toggle_float_win()
end, { silent = true, noremap = true, desc = 'toggle signature' })
vim.keymap.set('i', '<C-z>', '<C-y>')

--
-- Terminal
-- Term Toggle Function
--

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>terminal<CR>', { desc = 'Open [T]erminal' })

local term_buf = nil
local term_win = nil

function TermToggle(width)
  width = 3.7 * width
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.cmd 'hide'
  else
    vim.cmd 'vertical new'
    local new_buf = vim.api.nvim_get_current_buf()
    vim.cmd('vertical resize ' .. width)
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.cmd('buffer ' .. term_buf) -- go to terminal buffer
      vim.cmd('bd ' .. new_buf) -- cleanup new buffer
    else
      vim.cmd 'terminal'
      term_buf = vim.api.nvim_get_current_buf()
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.signcolumn = 'no'
    end
    vim.cmd 'startinsert!'
    term_win = vim.api.nvim_get_current_win()
  end
end

-- Term Toggle Keymaps
vim.keymap.set('n', '<A-t>', ':lua TermToggle(20)<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<A-t>', '<Esc>:lua TermToggle(20)<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<A-t>', '<C-\\><C-n>:lua TermToggle(20)<CR>', { noremap = true, silent = true })

--
-- TEST
--
vim.keymap.set('n', '<leader>p', function()
  local buffCount = #vim.api.nvim_list_bufs()
  local winscountnt = #vim.api.nvim_list_wins()
  print('buffer count is ' .. buffCount)
  print('window count is ' .. winscountnt)
end)

--
--
--

--
-- Explorer : Open/Close
--
vim.keymap.set('n', '<leader>e', function()
  local total_win_count = #vim.api.nvim_list_wins()
  local tree_win_count = 0

  for key, win_value in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win_value)
    print(key, win_value)
    local opt_value = vim.api.nvim_get_option_value('filetype', { buf = buf })
    print(opt_value)
    if opt_value == 'netrw' then
      print 'has found some open Tree buffers'
      vim.api.nvim_win_hide(win_value)
      tree_win_count = tree_win_count + 1
    end
  end

  if tree_win_count == 0 or total_win_count == 1 then
    print 'trying to reopen Explorer'
    vim.api.nvim_exec(':Vexplore ', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>H', true, true, true), 'n', true)
  end
  -- vim.api.nvim_list_bufs()
  -- local wins = vim.api.nvim_list_wins()
  -- local wins = vim.api.nvim_win_close()
  -- local wins = vim.api.nvim_win_get_buf()
  -- nvim_get_option_info2({name}, {opts})
end, { desc = 'Open/Close [E]xplorer' })

vim.keymap.set('n', '<A-1>', '<leader>e', { desc = 'Open/Close [E]xplorer' })

--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('i', '<A-h>', '<C-\\><C-N><C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('i', '<A-j>', '<C-\\><C-N><C-w>j', { desc = 'Move focus to the down window' })
vim.keymap.set('i', '<A-k>', '<C-\\><C-N><C-w>k', { desc = 'Move focus to the above window' })
vim.keymap.set('i', '<A-l>', '<C-\\><C-N><C-w>l', { desc = 'Move focus to the right window' })

vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w>j', { desc = 'Move focus to the down window' })
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w>k', { desc = 'Move focus to the above window' })
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w>l', { desc = 'Move focus to the right window' })

--
--
-- Keybinds to increase\decrease windowsize
--
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
--

vim.keymap.set('n', '<A-S-l>', [[<cmd>vertical resize +5<cr>]])
vim.keymap.set('n', '<A-S-h>', [[<cmd>vertical resize -5<cr>]])
vim.keymap.set('n', '<A-S-j>', [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set('n', '<A-S-k>', [[<cmd>horizontal resize -2<cr>]])

vim.keymap.set('i', '<A-S-l>', [[<cmd>vertical resize +5<cr>]])
vim.keymap.set('i', '<A-S-h>', [[<cmd>vertical resize -5<cr>]])
vim.keymap.set('i', '<A-S-j>', [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set('i', '<A-S-k>', [[<cmd>horizontal resize -2<cr>]])

vim.keymap.set('t', '<A-S-l>', [[<cmd>vertical resize +5<cr>]])
vim.keymap.set('t', '<A-S-h>', [[<cmd>vertical resize -5<cr>]])
vim.keymap.set('t', '<A-S-j>', [[<cmd>horizontal resize +2<cr>]])
vim.keymap.set('t', '<A-S-k>', [[<cmd>horizontal resize -2<cr>]])

--
--
-- quick fix: navigation
--
vim.keymap.set('n', '<A-2>', '<cmd>cnext<cr>', { desc = 'Move to next Quick Fix' })
vim.keymap.set('n', '<A-1>', '<cmd>cprevious<cr>', { desc = 'Move to previous Quick Fix' })

vim.keymap.set('n', '<leader>ll', function()
  local win = vim.api.nvim_get_current_win()
  local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
  local action = qf_winid > 0 and 'lclose' or 'lopen'
  vim.cmd(action)
end, { desc = '[L]list Of [L]ocations' })

vim.keymap.set('n', '<leader>lq', function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  local action = qf_winid > 0 and 'cclose' or 'copen'
  vim.cmd('botright ' .. action)
end, { desc = '[L]list Of [Q]uickFix' })

vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, { desc = '[L]list Of [D]iagnostic' })

--
--
-- ****************************************************************
-- ***************************** Move Tabs
--

-- vim.keymap.set('n', '<A-4>', '<cmd>tabnext<cr>', { desc = 'Move to next Tab' })
vim.keymap.set('n', '<C-A-l>', '<cmd>tabnext<cr>', { desc = 'Move to next Tab' })
vim.keymap.set('n', '<C-A-h>', '<cmd>tabprevious<cr>', { desc = 'Move to previous Tab' })
--
--
-- autocomplete
-- [ DOES NOT WORKS ]
-- WARNING: NEED FIXING
--
-- vim.keymap.set('i', '<C-cr>', '<C-y>', { desc = 'autocomplete from suggestion' })
-- vim.keymap.set("i", "<C-j>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
-- vim.keymap.set("i", "<C-j>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- let g:netrw_list_hide= netrw_gitignore#Hide()
-- vim.opt_global.netrw_list_hide = vim.fn['netrw_gitignore#Hide']()
return {

  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function(plugin)
      if vim.fn.executable 'npx' then
        vim.cmd('!cd ' .. plugin.dir .. ' && cd app && npx --yes yarn install')
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn['mkdp#util#install']()
      end
    end,
    init = function()
      if vim.fn.executable 'npx' then
        vim.g.mkdp_filetypes = { 'markdown' }
      end
    end,
  },
  -- {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   config = function()
  --     local null_ls = require 'null-ls'
  --     null_ls.setup {
  --       gksources = {
  --         null_ls.builtins.diagnostics.pylint.with {
  --           diagnostic_config = { underline = false, virtual_text = false, signs = false },
  --           method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
  --         },
  --       },
  --     }
  -- null_ls.setup {
  --   sources = {
  --     null_ls.builtins.formatting.stylua,
  --     null_ls.builtins.diagnostics.eslint,
  --     null_ls.builtins.completion.spell,
  --   },
  -- }
  --   end,
  -- },
  {
    'DasGandlaf/nvim-autohotkey',
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require 'nvim-autohotkey'
      require('cmp').setup.filetype({ 'autohotkey' }, {
        sources = { { name = 'autohotkey' } },
      })
    end,
  },
  {

    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- signs = false,
    },
  },
  {

    'windwp/nvim-ts-autotag',
    opts = {},
  },

  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
      'neovim/nvim-lspconfig', -- optional
    },
    config = function()
      vim.keymap.set('n', '<leader>ts', '<cmd>TailwindSort<CR>')
      vim.keymap.set('n', '<leader>tc', '<cmd>TailwindConcealToggle<CR>')
      require('tailwind-tools').setup {}
    end,
  },

  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      -- Your options go here
      -- name = "venv",
      -- auto_refresh = false
    },
    -- event = 'eryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
    },
  },
  -- {
  --   'mfussenegger/nvim-lint',
  --   config = function()
  --     require('lint').linters_by_ft = {
  --       python = { 'flake8' }, --'mypy'
  --       vim = { 'vint' },
  --       sh = { 'shellcheck' },
  --     }
  --
  --     vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  --       callback = function()
  --         require('lint').try_lint()
  --       end,
  --     })
  --   end,
  -- },
  {
    'dense-analysis/ale',
    config = function()
      -- Configuration goes here.
      local g = vim.g

      -- g.ale_ruby_rubocop_auto_correct_all = 1

      g.ale_linters = {
        -- ruby = { 'rubocop', 'ruby' },
        -- lua = { 'lua_language_server' },
        python = { 'flake8', 'mypy' },
      }
    end,
  },
}

--[[

  Neovim Config by 

        ███████╗  █████╗  ██╗  ██╗ ██╗ ██████╗
        ╚══███╔╝ ██╔══██╗ ██║ ██╔╝ ██║ ██╔══██╗
          ███╔╝  ███████║ █████╔╝  ██║ ██████╔╝
         ███╔╝   ██╔══██║ ██╔═██╗  ██║ ██╔══██╗
        ███████╗ ██║  ██║ ██║  ██╗ ██║ ██║  ██║
        ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝  ╚═╝
                                                 ✨

      ╭────────────────────────────────────────────╮
      │    Welcome back, Zakir! Time to vibe.     │
      │   ⚙️  Your Neovim spaceship is ready.        │
      │   🧠  Code smarter. Hack cleaner.            │
      ╰────────────────────────────────────────────╯
               \
                \
                 .--.
                |o_o |
                |:_/ |
               //   \ \
              (|     | )
             /'\_   _/`\
             \___)=(___/
============================================================|
============= No Mice Were Harmed in This Setup ============|
============================================================|

--]]

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
require('options').setup()
require('keys').setup()
require('shell').setup()
require('diagnostics').setup()

require('lazy').setup({
  spec = {
    -- directories =>
    { import = 'plugins.lsp' },
    { import = 'plugins.tree-sitter' },
    { import = 'plugins.ui' },
    { import = 'plugins.file-manager' },
    { import = 'plugins.version-control' },
    { import = 'plugins.ai' },
    { import = 'plugins.specific' },
    { import = 'plugins.others' },
    -- files =>
    -- {
    --   name = 'after-telescope',
    --   event = 'VeryLazy',
    --   dependencies = {
    --     'nvim-telescope/telescope.nvim',
    --   },
    --   config = function()
    --   end,
    -- },
  },
  change_detection = { notify = false },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- require('kickstart.plugins.neo-tree'),
-- require 'kickstart.plugins.gitsigns',
-- require 'kickstart.plugins.autopairs',
-- require 'kickstart.plugins.indent_line',
-- require 'kickstart.plugins.debug',
-- require 'kickstart.plugins.lint',

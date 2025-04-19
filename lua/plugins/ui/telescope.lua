return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = function()
        if vim.fn.has('win32') == 1 then
          return 'enter-vsshel.ps1 && cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        else
          return 'make'
        end
      end,
      cond = function()
        return vim.fn.executable('make') == 1 or vim.fn.executable('enter-vsshell.ps1')
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup({
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    require('autocmds').setup_lsp_autocmds()
    local key_map = require('keys')
    key_map.setup_telescope_keybind()
    key_map.setup_fix_list_diagnostic_keybind()
  end,
}

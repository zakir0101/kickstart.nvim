-- check path exist :
local path = nil
if vim.fn.isdirectory('D:\\Projects\\avante.nvim') ~= 0 then
  path = 'D:\\Projects\\avante.nvim'
end

return {
  'zakir0101/avante.nvim',
  dir = path,
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  opts = {
    chat_model = 'o3-mini-2025-01-31',
    debug = true,
    vendors = {},
  },
  build = (function()
    if not vim.fn.executable('cargo') then
      error('Avante module depend on some rust modules, please install rust and cargo first')
      return ''
    end
    if vim.fn.has('win32') == 1 then
      return 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource true'
    else
      return 'make BUILD_FROM_SOURCE=true'
    end
  end)(),

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'hrsh7th/nvim-cmp', -- autocompletion
    -- file_selector
    'echasnovski/mini.pick',
    'nvim-telescope/telescope.nvim',
    'ibhagwan/fzf-lua',
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
    'MeanderingProgrammer/render-markdown.nvim',
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}

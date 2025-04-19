local ensure_installed_ls = {
  'rust_analyzer',
  'lua_ls',
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
  'powershell_es',
}
local USE_BLINK = true
-- vim.lsp.config('*', {
--   root_markers = { '.git' },
-- })
return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = true,
      },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    opts = {
      ensure_installed = ensure_installed_ls,
    },
  },

  {
    'neovim/nvim-lspconfig',
    branch = 'master',
    -- **
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function() end,
  },
  {

    'williamboman/mason-lspconfig.nvim',
    -- **
    dependencies = {
      'neovim/nvim-lspconfig',
      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },

    config = function()
      local setup_an_lsp = function(server_name)
        -- print('SERVER_NAME: ', server_name)
        if USE_BLINK then
          local default_capabilities = vim.lsp.protocol.make_client_capabilities()
          local user_capabilities = (vim.lsp.config[server_name] or {}).capabilities or {}
          local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
          local final_capabilities = vim.tbl_deep_extend('force', default_capabilities, blink_capabilities, user_capabilities)
          local all_config = vim.lsp.config[server_name]
          all_config.capabilities = final_capabilities
          vim.lsp.config(server_name, all_config)
          if false and server_name == 'pyright' then
            -- print(vim.inspect(default_capabilities))
            -- print(vim.inspect(user_capabilities))
            -- print(vim.inspect(blink_capabilities))
            print(vim.inspect(final_capabilities))
          end
        end
        vim.lsp.enable(server_name)
      end

      require('mason-lspconfig').setup({
        handlers = { setup_an_lsp },
      })
    end,
  },
}

-- 'williamboman/mason-lspconfig.nvim',
-- Allows extra capabilities provided by nvim-cmp
-- 'hrsh7th/cmp-nvim-lsp',

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
-- j
-- handlers = {
--   function(server_name)
--     if vim.tbl_contains(install_only, server_name) then
--       return
--     end
--     local server = servers[server_name] or {}
--     server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--     require('lspconfig')[server_name].setup(server)
--   end,
-- },
-- })

return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  -- build = 'cargo build --release', -- for delimiters
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'default', --'default',
      ['<C-z>'] = {
        'select_and_accept',
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { menu = { auto_show = true }, documentation = { auto_show = true } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}

---@deprecated
-- local cmp = {
--   'hrsh7th/nvim-cmp',
--   event = 'InsertEnter',
--   dependencies = {
--     {
--       'L3MON4D3/LuaSnip',
--       build = (function()
--         if vim.fn.has('win32') == 1 then
--           return 'cmake'
--         elseif vim.fn.executable('make') == 0 then
--           return 'make install_jsregexp'
--         end
--       end)(),
--     },
--     'saadparwaiz1/cmp_luasnip',
--     'hrsh7th/cmp-nvim-lsp',
--     'hrsh7th/cmp-path',
--     -- 'tailwind-tools',
--     'onsails/lspkind-nvim',
--   },
--   config = function()
--     local cmp = require('cmp')
--     local luasnip = require('luasnip')
--     local lspkind = require('lspkind')
--     luasnip.config.setup({})
--     cmp.status()
--     cmp.setup({
--       snippet = {
--         expand = function(args)
--           luasnip.lsp_expand(args.body)
--         end,
--       },
--       completion = { completeopt = 'menu,menuone,noinsert' },
--
--       window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--       },
--
--       mapping = cmp.mapping.preset.insert({
--         ['<C-n>'] = cmp.mapping.select_next_item(),
--         ['<C-p>'] = cmp.mapping.select_prev_item(),
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-z>'] = cmp.mapping.confirm({ select = true }),
--
--         ['<C-Space>'] = cmp.mapping.complete({}),
--         ['<A-l>'] = cmp.mapping(function()
--           if luasnip.expand_or_locally_jumpable() then
--             luasnip.expand_or_jump()
--           end
--         end, { 'i', 's' }),
--         ['<A-h>'] = cmp.mapping(function()
--           if luasnip.locally_jumpable(-1) then
--             luasnip.jump(-1)
--           end
--         end, { 'i', 's' }),
--       }),
--       sources = {
--         {
--           name = 'lazydev',
--           group_index = 0,
--         },
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--         { name = 'path' },
--         { name = 'autohotkey' },
--       },
--
--       formatting = {
--         format = lspkind.cmp_format({
--           before = require('tailwind-tools.cmp').lspkind_format,
--         }),
--       },
--     })
--   end,
-- }

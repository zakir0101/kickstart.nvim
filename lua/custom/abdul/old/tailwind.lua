return {
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
}

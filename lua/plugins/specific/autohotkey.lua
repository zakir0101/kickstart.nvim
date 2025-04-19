return {

  {
    'DasGandlaf/nvim-autohotkey',
    dependencies = {
      'jose-elias-alvarez/null-ls.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('nvim-autohotkey')
      require('cmp').setup.filetype({ 'autohotkey' }, {
        sources = { { name = 'autohotkey' } },
      })
    end,
  },
}

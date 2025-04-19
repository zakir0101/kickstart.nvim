return {
  cmd = { 'clangd' },
  -- root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'c', 'cpp' },
  on_attach = function(_, bufnr)
    vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>', { silent = true, buffer = bufnr })
  end,
}

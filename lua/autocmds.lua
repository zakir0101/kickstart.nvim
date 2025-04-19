local M = {}
local keys = require('keys')

M.lsp_attach_group = vim.api.nvim_create_augroup('lsp-attach-group', { clear = true })
M.lsp_detach_group = vim.api.nvim_create_augroup('lsp-detach-group', { clear = true })
M.highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight-group', { clear = false })

function M.setup_lsp_autocmds()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = M.lsp_attach_group,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local buf = event.buf
      local does_support_highlight = client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf)
      local does_support_inlayhint = client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buf)
      local does_support_autocomplete =
        client and client:supports_method('textDocument/completion', buf),
        --
        -- setup keymaps for LSP
        keys.setup_buffer_specific_telescope_keybind(buf)
      keys.setup_buffer_specific_lsp_keybind(buf)
      -- if does_support_autocomplete then
      --   -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      --   -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      --   -- client.server_capabilities.completionProvider.triggerCharacters = chars
      --
      --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      -- end
      -- if the client supports document highlight
      if does_support_highlight then
        M.setup_document_highlight_on_cursor_hold(buf)
        M.setup_clear_references_on_cursor_moved(buf)
        M.setup_on_lsp_detach_autocmd()
      end
      if does_support_inlayhint then
        keys.setup_buffer_specific_inlayhints_keybind(buf)
      end
    end,
  })
end
function M.setup_document_highlight_on_cursor_hold(buf)
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    buffer = buf,
    group = M.highlight_augroup,
    callback = vim.lsp.buf.document_highlight,
  })
end
function M.setup_clear_references_on_cursor_moved(buf)
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    buffer = buf,
    group = M.highlight_augroup,
    callback = vim.lsp.buf.clear_references,
  })
end
function M.setup_on_lsp_detach_autocmd()
  vim.api.nvim_create_autocmd('LspDetach', {
    group = M.lsp_detach_group,
    callback = function(event2)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds({ group = M.highlight_augroup, buffer = event2.buf })
    end,
  })
end

return M

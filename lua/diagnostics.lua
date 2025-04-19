local M = {}

function M.configure_diagnostics()
  local diagnostic_config = {

    severity_sort = true,
    update_in_insert = true,
    virtual_lines = false,
    underline = { severity = vim.diagnostic.severity.ERROR },
  }

  if vim.g.have_nerd_font then
    local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' or '󰌶 ' }

    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.tbl_extend('force', diagnostic_config, { signs = { text = diagnostic_signs } })
  end

  vim.diagnostic.config(diagnostic_config)
end

-- See :help vim.diagnostic.Opts
function M.setup()
  M.configure_diagnostics()
end

return M

local M = {}

function M.setup()
  if vim.fn.has('win32') == 1 then
    local shell = vim.fn.executable('pwsh') and 'pwsh.exe' or 'powershell.exe'
    os.execute('. ' .. shell .. ' -Command { $PSStyle.FileInfo.Directory = "`e[100;1m" } ')
    vim.o.shell = shell
    -- '"C:\\Program Files\\PowerShell\\7\\pwsh.exe"'
    vim.o.shellcmdflag =
      '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command  [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
  elseif vim.fn.executable('zsh') then
    vim.o.shell = 'zsh'
  end
end

return M

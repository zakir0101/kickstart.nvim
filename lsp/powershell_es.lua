local temp_path = vim.fn.stdpath('cache')
local util = require('lspconfig.util')

local function make_cmd()
  -- path is in :
  -- C:\Users\zakir\AppData\Local\nvim-data\mason\packages\powershell-editor-services\
  local data_path = vim.fn.stdpath('data')
  local bundle_path = vim.fs.joinpath(data_path, 'mason', 'packages', 'powershell-editor-services')
  local shell = 'pwsh.exe'
  local command_fmt = {
    shell,
    '-NoLogo',
    '-NoProfile',
    '-File',
    bundle_path .. '/PowerShellEditorServices/Start-EditorServices.ps1',
    '-BundledModulesPath',
    bundle_path,
    '-LogPath ',
    temp_path .. '/powershell_es.log',
    '-SessionDetailsPath',
    temp_path .. '/powershell_es.session.json',
    '-HostName',
    'nvim',
    '-HostProfileId',
    '0',
    '-HostVersion',
    '1.0.0',
    '-Stdio',
  }
  -- local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)
  -- local args = table.concat({ '-NoLogo', '-NoProfile', '-File ', command }, ' ')
  return command_fmt
end

return {
  cmd = make_cmd(),
  filetypes = { 'ps1', 'psd1', 'psm1' },
  root_markers = { '.git' },
}

-- example :
-- return {
--   cmd = { 'lua-language-server' },
--   filetypes = { 'lua' },
--   root_markers = {
--     '.luarc.json',
--     '.luarc.jsonc',
--     '.luacheckrc',
--     '.stylua.toml',
--     'stylua.toml',
--     'selene.toml',
--     'selene.yml',
--     '.git',
--   },
-- }
--[[
https://github.com/PowerShell/PowerShellEditorServices

Language server for PowerShell.

To install, download and extract PowerShellEditorServices.zip
from the [releases](https://github.com/PowerShell/PowerShellEditorServices/releases).
To configure the language server, set the property `bundle_path` to the root
of the extracted PowerShellEditorServices.zip.

The default configuration doesn't set `cmd` unless `bundle_path` is specified.

```lua
require'lspconfig'.powershell_es.setup{
  bundle_path = 'c:/w/PowerShellEditorServices',
}
```

By default the languageserver is started in `pwsh` (PowerShell Core). This can be changed by specifying `shell`.

```lua
require'lspconfig'.powershell_es.setup{
  bundle_path = 'c:/w/PowerShellEditorServices',
  shell = 'powershell.exe',
}
```

Note that the execution policy needs to be set to `Unrestricted` for the languageserver run under PowerShell

If necessary, specific `cmd` can be defined instead of `bundle_path`.
See [PowerShellEditorServices](https://github.com/PowerShell/PowerShellEditorServices#stdio)
to learn more.

```lua
require'lspconfig'.powershell_es.setup{
  cmd = {'pwsh', '-NoLogo', '-NoProfile', '-Command', "c:/PSES/Start-EditorServices.ps1 ..."}
}
```
]]
--,

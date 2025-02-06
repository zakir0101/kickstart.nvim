return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local augroup = vim.api.nvim_create_augroup
            local LspAttachGroup = augroup('my-lsp-attach', { clear = true })
            vim.api.nvim_create_autocmd('LspAttach', {
                group = LspAttachGroup,
                callback = function(event)
                    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, {})
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

                    vim.keymap.set('n', '[d', vim.diagnostic.goto_next, {})
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, {})

                    local builtin = require 'telescope.builtin'
                    vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
                    vim.keymap.set('n', 'gr', builtin.lsp_references, {})
                    vim.keymap.set('n', 'gI', builtin.lsp_implementations, {})
                    vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions, {})
                    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                clangd = {
                    cmd = { 'clangd' },
                    on_attach = function(client, bufnr)
                        vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>', { silent = true, buffer = bufnr })
                    end,
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
                pyright = {
                    handlers = {
                        ['textDocument/publishDiagnostics'] = function() end,
                    },
                    settings = {
                        pyright = {
                            disableOrganizeImports = true,
                        },
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                typeCheckingMode = 'off',
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                },
            }

            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            local install_only = { 'tailwindcss' }
            vim.list_extend(ensure_installed, {
                'neocmakelsp',
                'stylua',
                'ruff',
                'black',
                'pyright',
                'ts_ls',
                'eslint',
                'html',
                'cssls',
                'prettier',
                'emmet-language-server',
            })
            vim.list_extend(ensure_installed, install_only)

            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        if vim.tbl_contains(install_only, server_name) then
                            return
                        end
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }

            vim.diagnostic.config {
                update_in_insert = true,
                signs = {
                    severity = {
                        min = vim.diagnostic.severity.WARN,
                    },
                    priority = 5, -- Lower priority for LSP diagnostics than gitsigns
                },
                -- underline = {
                --     severity = {
                --         min = vim.diagnostic.severity.ERROR,
                --     },
                -- },
                float = {
                    focusable = false,
                    style = '',
                    border = 'rounded',
                    source = true,
                    header = '',
                    prefix = '',
                },
            }

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = 'rounded',
            })
        end,
    },
}

local Util = require("albertocerrone.util")

-- Keymaps
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", Util.telescope("lsp_document_symbols"), "[D]ocument [S]ymbols")
    nmap("<leader>ws", Util.telescope("lsp_dynamic_workspace_symbols"), "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

return {
    {
        "simrat39/rust-tools.nvim",
        ft = { 'rust' },
        opts = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            return {
                server = {
                    on_attach = on_attach,
                    capabilities = capabilities
                },
                tools = {
                    runnables = {
                        use_telescope = true,
                    },
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = false,
                        parameter_hints_prefix = "",
                        other_hints_prefix = "",
                    },
                },
            }
        end,
        config = function(_, opts)
            require("rust-tools").setup(opts)
        end,
        dependencies = {
            'nvim-lspconfig',
            -- Adds extra functionality over rust analyzer
            {
                'rust-lang/rust.vim',
                ft = { 'rust' },
            },
        },
    },
    -- inlay hints
    {
        "lvimuser/lsp-inlayhints.nvim",
        event = "LspAttach",
        opts = {},
        config = function(_, opts)
            require("lsp-inlayhints").setup(opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp-inlayhints").on_attach(client, args.buf)
                end,
            })
        end,
    },
    {
      -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                float = {
                    border = 'rounded',
                    header = '',
                    prefix = '',
                    source = 'always',
                },
                severity_sort = true,
                signs = true,
                underline = true,
                update_in_insert = true,
                virtual_text = { prefix = "●"},
            },
            -- diagnostics signs
            signs = { Error = "", Warn = "", Hint = "", Info = "" },
            servers = {
                -- clangd = {},
                -- gopls = {},
                -- tsserver = {},
                sourcery = {},
                ruff_lsp = {
                    init_options = {
                        settings = {
                            args = {},
                        },
                    },
                },
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        completion = { callSnippet = "Replace", }
                    },
                },
            }
        },
        config = function(_, opts)
            -- diagnostics
            for type, icon in pairs(opts.signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
            vim.diagnostic.config(opts.diagnostics)
            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            -- Ensure the servers above are installed
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
            vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

            -- LSP settings (for overriding per client)
            local handlers = {
                    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
                    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
            }

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        handlers = handlers,
                    })
                end,
            })
            require("lspconfig")["pyright"].setup{
                capabilities = capabilities,
                settings = {},
                handlers = handlers,
                on_attach = function(client, buffer)
                    -- This is to stop suggestions from pyright. I just need LSP feature
                    client.handlers["textDocument/publishDiagnostics"] = function(...) end
                    on_attach(client, buffer)
                end,
            }
        end,
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Manage global and project-local settings.
            { 'folke/neoconf.nvim',  cmd = 'Neoconf',                                config = true },
            -- Additional lua configuration, makes nvim stuff amazing
            { "folke/neodev.nvim",   opts = { experimental = { pathStrict = true } } },

            { 'hrsh7th/cmp-nvim-lsp' },


            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim',   config = true }
        },
    },
    {
        -- Add linting support
        'jose-elias-alvarez/null-ls.nvim',
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    nls.builtins.code_actions.gitsigns,
                    nls.builtins.formatting.black,
                    nls.builtins.formatting.prettier.with({
                        prefer_local = "node_modules/.bin",
                    }),
                    -- nls.builtins.formatting.eslint.with({
                    --     prefer_local = "node_modules/.bin",
                    -- }),
                    -- nls.builtins.formatting.fish_indent,
                    -- nls.builtins.formatting.taplo,
                    -- nls.builtins.formatting.terraform_fmt,
                    nls.builtins.formatting.trim_newlines,
                    nls.builtins.formatting.trim_whitespace,
                    nls.builtins.formatting.uncrustify,
                    nls.builtins.diagnostics.eslint.with({
                        prefer_local = "node_modules/.bin",
                    }),
                    nls.builtins.diagnostics.flake8.with({
                        prefer_local = ".venv/bin",
                    }),
                    nls.builtins.diagnostics.mypy.with({
                        prefer_local = ".venv/bin",
                        -- command = { 'python', '-m', 'mypy' }
                    }),
                    -- nls.builtins.diagnostics.shellcheck,
                    -- nls.builtins.diagnostics.hadolint,
                    -- nls.builtins.code_actions.eslint.with({
                    --     prefer_local = "node_modules/.bin",
                    -- }),
                }
            }
        end
    },
    dependencies = {
        'mason.nvim',
        {
            'jay-babu/mason-null-ls.nvim',
            opts = {
                ensure_installed = { "stylua", "shellcheck", "shfmt", "flake8", "prettier", "mypy" },
                automatic_installation = false,
                automatic_setup = true, -- Recommended, but optional
            },
            config = function()
                require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.
            end
        },
    },
    {
        'williamboman/mason.nvim',
        cmd = "Mason",
        config = true,
    },
}
-- -- Configure LSP through rust-tools.nvim plugin.
-- -- rust-tools will configure and enable certain LSP features for us.
-- -- See https://github.com/simrat39/rust-tools.nvim#configuration
-- local opts = {
--   tools = {
--     runnables = {
--       use_telescope = true,
--     },
--     inlay_hints = {
--       auto = true,
--       show_parameter_hints = false,
--       parameter_hints_prefix = "",
--       other_hints_prefix = "",
--     },
--   },
--
--   -- all the opts to send to nvim-lspconfig
--   -- these override the defaults set by rust-tools.nvim
--   -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
--   server = {
--     -- on_attach is a callback called when the language server attachs to the buffer
--     on_attach = on_attach,
--     settings = {
--       -- to enable rust-analyzer settings visit:
--       -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--       ["rust-analyzer"] = {
--         imports = {
--           granularity = {
--             group = "module",
--           },
--           prefix = "self",
--         },
--         cargo = {
--           buildScripts = {
--             enable = true,
--           },
--         },
--         procMacro = {
--           enable = true
--         },
--         -- enable clippy on save
--         checkOnSave = {
--           command = "clippy",
--         },
--       },
--     },
--   },
-- }
--

-- local tabnine = require('cmp_tabnine.config')
return {
    -- snippets
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
        opts = {
            history = true,
            delete_check_events = 'TextChanged',
        },
        -- stylua: ignore
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true, silent = true, mode = "i",
            },
            { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
            { "<s-tab>", function() require("luasnip").jump( -1) end, mode = { "i", "s" } },
        },
    },
    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        opts = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local lspkind = require 'lspkind'

            return {
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-f>'] = cmp.mapping.scroll_docs( -4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Tab>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable( -1) then
                            luasnip.jump( -1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources {
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lsp' },
                    { name = 'cmp_tabnine' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                },
                formatting = {
                    -- Set up nice formatting for your sources.
                    format = lspkind.cmp_format {
                        with_text = true,
                        menu = {
                            buffer = '[buf]',
                            nvim_lsp = '[LSP]',
                            nvim_lua = '[api]',
                            cmp_tabnine = '[TabNine]',
                            path = '[path]',
                            luasnip = '[snip]',
                            gh_issues = '[issues]',
                        },
                    },
                },
                experimental = {
                    ghost_text = true,
                },
            }
        end,
        dependencies = {
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-vsnip'},
            {'hrsh7th/cmp-nvim-lsp-signature-help'},
            {'hrsh7th/cmp-nvim-lua'},
            {'hrsh7th/cmp-path'},
            {'onsails/lspkind-nvim'},
            {'saadparwaiz1/cmp_luasnip'},
            {
                'tzachar/cmp-tabnine',
                build = './install.sh',
                opts = {
                    max_lines = 1000,
                    max_num_results = 20,
                    sort = true,
                    run_on_every_keystroke = true,
                    snippet_placeholder = '..',
                    ignored_file_types = {
                        -- default is not to ignore
                        -- uncomment to ignore in lua:
                        -- lua = true
                    },
                    show_prediction_strength = false,
                },
            },
        },
    },
}

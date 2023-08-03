-- local tabnine = require('cmp_tabnine.config')
return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.copilot_filetypes = {
        ['chatgpt'] = false,
        ['dap-repl'] = false,
      }
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.cmd 'imap <silent><script><expr> <C-a> copilot#Accept("\\<CR>")'
    end,
  },
  -- auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {
        ---@usage check treesitter
        check_ts = true,
        ts_config = {
          lua = { 'string', 'source' },
          javascript = { 'string', 'template_string' },
          java = false,
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
      }
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'hrsh7th/nvim-cmp' },
  },
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function(_, opts)
      if opts then
        require('luasnip').config.setup(opts)
      end
      vim.tbl_map(function(type)
        require('luasnip.loaders.from_' .. type).lazy_load()
      end, { 'vscode', 'snipmate', 'lua' })
      require('luasnip').filetype_extend('python', { 'django-rest', 'django' })
      require('luasnip').filetype_extend('htmldjango', { 'html' })
    end,
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
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    opts = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind_status_ok, lspkind = pcall(require, 'lspkind')

      local border_opts = {
        border = 'single',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
      }
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end
      local compare = require 'cmp.config.compare'
      return {
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = lspkind.cmp_format {
            mode = 'symbol',
            symbol_map = {
              Array = ' ',
              Boolean = ' ',
              Class = ' ',
              Color = ' ',
              Constant = ' ',
              Constructor = ' ',
              Copilot = ' ',
              Enum = ' ',
              EnumMember = ' ',
              Event = ' ',
              Field = ' ',
              File = ' ',
              Folder = ' ',
              Function = ' ',
              Interface = ' ',
              Key = ' ',
              Keyword = ' ',
              Method = ' ',
              Module = ' ',
              Namespace = ' ',
              Null = ' ',
              Number = ' ',
              Object = ' ',
              Operator = ' ',
              Package = ' ',
              Property = ' ',
              Reference = ' ',
              Snippet = ' ',
              String = ' ',
              Struct = ' ',
              Text = ' ',
              TypeParameter = ' ',
              Unit = ' ',
              Value = ' ',
              Variable = ' ',
            },
          },
        },

        sorting = {
          priority_weight = 1.0,
          comparators = {
            compare.locality,
            compare.recently_used,
            compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            compare.offset,
            compare.order,
          },
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-f>'] = cmp.mapping.scroll_docs(-4),
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
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        sources = cmp.config.sources {
          -- { name = 'cmp_tabnine' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp', max_item_count = 8, priority = 8 },
          { name = 'luasnip', priority = 7 },
          { name = 'buffer', priority = 7 },
          { name = 'spell', keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] },
          { name = 'nvim_lua', priority = 5 },
          {
            name = 'html-css',
            option = {
              file_types = {
                'html',
                'htmldjango',
              },
              -- css_file_types = {},
              style_sheets = {
                'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css',
              },
            },
            priority = 5,
          },
          -- { name = 'path', priority = 4 },
          { name = 'fuzzy_path', priority = 4 }, -- from tzacher
          { name = 'calc', priority = 3 },
        },
        experimental = {
          ghost_text = false,
        },
      }
    end,
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-path' },
      { 'tzachar/cmp-fuzzy-path', dependencies = { 'tzachar/fuzzy.nvim' } },
      {
        'onsails/lspkind-nvim',
        opts = {},
        config = function(_, opts)
          if opts then
            require('lspkind').init(opts)
          end
        end,
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'saadparwaiz1/cmp_luasnip' },
      -- {
      --   'Jezda1337/nvim-html-css',
      --   init = function()
      --     require('html-css'):setup()
      --   end,
      -- },
      -- {
      --     'tzachar/cmp-tabnine',
      --     build = './install.sh',
      --     opts = {
      --         max_lines = 1000,
      --         max_num_results = 20,
      --         sort = true,
      --         run_on_every_keystroke = true,
      --         snippet_placeholder = '..',
      --         ignored_file_types = {
      --             -- default is not to ignore
      --             -- uncomment to ignore in lua:
      --             -- lua = true
      --         },
      --         show_prediction_strength = false,
      --     },
      -- },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
}
}

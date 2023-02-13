return {
   {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Add linting support
      "jose-elias-alvarez/null-ls.nvim",
      "jay-babu/mason-null-ls.nvim",

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },


  -- Adds extra functionality over rust analyzer
  "rust-lang/rust.vim",
  -- "simrat39/rust-tools.nvim",  # TODO: It depends on DAP and other tools

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip','hrsh7th/cmp-nvim-lsp-signature-help', 'hrsh7th/cmp-nvim-lua', 'hrsh7th/cmp-path', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', },
  },
  {
    'tzachar/cmp-tabnine',
    build = './install.sh',
    dependencies = 'hrsh7th/nvim-cmp'
  },
  "onsails/lspkind-nvim",

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    }
  },

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    keys = {
      {
        "<leader>gt",
        function ()
          vim.cmd.Git()
          vim.api.nvim_command("normal! 5j")
        end
      }
    },
    cmd = "Git",
    dependencies = 'tpope/vim-rhubarb',
    config = function (_, opts)
      local Alberto_Fugitive = vim.api.nvim_create_augroup("Alberto_Fugitive", {})

      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufWinEnter", {
        group = Alberto_Fugitive,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
          end, opts)

          -- rebase always
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ 'pull', '--rebase' })
          end, opts)

          -- NOTE: It allows me to easily set the branch i am pushing and any tracking
          -- needed if i did not set the branch up correctly
          vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
        end,
      })
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        untracked    = { hl = 'GitSignsAdd', text = '┆', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      },
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm = {
        enable = false
      },
    }
  },


  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",

    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    config = {
      options = {
        icons_enabled = true,
        theme = 'ayu_mirage',
        component_separators = { left = '|', right = '|' },
        -- section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
  {
    'numToStr/Comment.nvim',-- "gc" to comment visual regions/lines
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    'tpope/vim-sleuth',-- Detect tabstop and shiftwidth automatically
    event = { "BufReadPost", "BufNewFile" }
  },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
      {
        "rcarriga/nvim-dap-ui",
        opts = {
          icons = { expanded = "▾", collapsed = "▸" },
          mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
              },
              size = 80,
              position = "left",
            },
            {
              elements = { "repl", "console" },
              size = 0.25,
              position = "bottom",
            },
          },
          render = {
            max_value_lines = 3,
          },
          floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        config = function ()
          require("dap-python").setup("~/.config/nvim/.virtualenvs/debugpy/bin/python")
        end
      }
    },
    opts = function ()
      local dap = require("dap")
      local dapui = require("dapui")
      
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      require('dap.ext.vscode').load_launchjs()
    end,
    keys = {
      {
        "<F5>",
        function ()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue"
      },
      {
        "<F3>",
        function ()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over"
      },
      {
        "<F2>",
        function ()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into"
      },
      {
        "<F12>",
        function ()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out"
      },
      {
        "<leader>b",
        function ()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint"
      },
      {
        "<leader>B",
        function ()
          require("dap").set_breakpoint(
            vim.fn.input("Breakpoint condition: ")
          )
        end,
        desc = "Debug: Set Breakpoint"
      },
      {
        "<leader>lp",
        function ()
          require("dap").set_breakpoint(
            nil,nil,vim.fn.input("Log point message: ")
          )
        end,
        desc = "Debug: Log point message"
      },
      {
        "<leader>dr",
        function ()
          require("dap").repl.open()
        end,
        desc = "Debug: Open REPL"
      },

    },
  },

  -- Winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true
  },
  {
    "windwp/nvim-spectre",
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "[S]earch and [R]eplace globaly" },
    },
  },
}

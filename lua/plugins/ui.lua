return {
  {
    'folke/tokyonight.nvim',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = function()
      return {
        style = 'night',
        -- transparent = true,
        -- styles = {
        --   sidebars = "transparent",
        --   floats = "transparent",
        -- },
        sidebars = {
          'qf',
          'vista_kind',
          'terminal',
          'spectre_panel',
          'startuptime',
          'Outline',
        },
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.LineNr = { fg = c.orange, bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          -- local prompt = "#2d3149"
          -- hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          -- hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopePromptNormal = { bg = prompt }
          -- hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          -- hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          -- hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
      }
    end,
    config = function(_, opts)
      require('tokyonight').setup(opts)
      -- load the colorscheme here
      vim.cmd [[colorscheme tokyonight-night]]
    end,
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- Winbar
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-web-devicons',
    },
    config = true,
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('colorizer').setup()
    end,
  },
  -- Fancy statusline
  {
    'nvim-lualine/lualine.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-web-devicons' },
    opts = function()
      local custom_fname = require('lualine.components.filename'):extend()
      local highlight = require 'lualine.highlight'
      local default_status_colors = { saved = '#242b38', modified = '#730808', fg = '#fcfcfc' }

      function custom_fname:init(options)
        custom_fname.super.init(self, options)
        self.status_colors = {
          saved = highlight.create_component_highlight_group(
            { bg = default_status_colors.saved, fg = default_status_colors.fg },
            'filename_status_saved',
            self.options
          ),
          modified = highlight.create_component_highlight_group(
            { bg = default_status_colors.modified, fg = default_status_colors.fg },
            'filename_status_modified',
            self.options
          ),
        }
        if self.options.color == nil then
          self.options.color = ''
        end
      end

      function custom_fname:update_status()
        local data = custom_fname.super.update_status(self)
        data = highlight.component_format_highlight(vim.bo.modified and self.status_colors.modified or
        self.status_colors.saved) .. data
        return data
      end

      return {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = false,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { { 'mode', color = { gui = 'bold' } } },
          lualine_b = {
            { custom_fname, symbols = { modified = '  ', readonly = '', unnamed = '' } },
          },
          lualine_c = {
            { 'branch',      icon = { ' ', align = 'right', color = { fg = 'orange' } } },
            { 'diff',        symbols = { added = ' ', modified = ' ', removed = ' ' } },
            { 'diagnostics', symbols = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' } },
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_ = {},
          lualine_b = { custom_fname },
          lualine_c = {},
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { 'lazy' },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      buftype_exclude = {
        'nofile',
        'terminal',
      },
      filetype_exclude = {
        'help',
        'startify',
        'aerial',
        'alpha',
        'dashboard',
        'lazy',
        'neogitstatus',
        'NvimTree',
        'neo-tree',
        'Trouble',
      },
      -- context_patterns = {
      -- 	"class",
      -- 	"return",
      -- 	"function",
      -- 	"method",
      -- 	"^if",
      -- 	"^while",
      -- 	"jsx_element",
      -- 	"^for",
      -- 	"^object",
      -- 	"^table",
      -- 	"block",
      -- 	"arguments",
      -- 	"if_statement",
      -- 	"else_clause",
      -- 	"jsx_element",
      -- 	"jsx_self_closing_element",
      -- 	"try_statement",
      -- 	"catch_clause",
      -- 	"import_statement",
      -- 	"operation_type",
      -- },
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      char = '▏',
      context_char = '▏',
      show_current_context = true,
    },
  },
  {
    'stevearc/dressing.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },

  -- Dashboard. Very Spicy
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
         $$$$$$\            $$\                     $$\    $$\ $$\
        $$  __$$\           \__|                    $$ |   $$ |\__|
        $$ /  \__| $$$$$$\  $$\  $$$$$$$\ $$\   $$\ $$ |   $$ |$$\ $$$$$$\$$$$\
        \$$$$$$\  $$  __$$\ $$ |$$  _____|$$ |  $$ |\$$\  $$  |$$ |$$  _$$  _$$\
         \____$$\ $$ /  $$ |$$ |$$ /      $$ |  $$ | \$$\$$  / $$ |$$ / $$ / $$ |
        $$\   $$ |$$ |  $$ |$$ |$$ |      $$ |  $$ |  \$$$  /  $$ |$$ | $$ | $$ |
        \$$$$$$  |$$$$$$$  |$$ |\$$$$$$$\ \$$$$$$$ |   \$  /   $$ |$$ | $$ | $$ |
         \______/ $$  ____/ \__| \_______| \____$$ |    \_/    \__|\__| \__| \__|
                  $$ |                    $$\   $$ |
                  $$ |                    \$$$$$$  |
                  \__|                     \______/          by albertocerrone 🔥
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("m", "  " .. "Mason", ":Mason<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}

return {
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = "Telescope",
    keys = {
      {'<leader>?', function() require('telescope.builtin').oldfiles() end, { desc = '[?] Find recently opened files' }},
      {'<leader>:', function() require('telescope.builtin').command_history() end, { desc = '[:] Find from command history' }},
      {'<leader><space>', function() require('telescope.builtin').buffers() end, { desc = '[ ] Find existing buffers' }},
      { '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 00,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer]' }},

      {'<leader>gs', function() require('telescope.builtin').git_status() end, { desc = 'Search [G]it [S]tatus' }},
      {'<leader>gc', function() require('telescope.builtin').git_commits() end, { desc = 'Search [G]it [C]ommits' }},
      {'<leader>ss', function() require('telescope.builtin').resume() end, { desc = 'Resume [S]earch' }},
      {'<leader>sf', function() require('telescope.builtin').find_files() end, { desc = '[S]earch [F]iles' }},
      {'<leader>sh', function() require('telescope.builtin').help_tags() end, { desc = '[S]earch [H]elp' }},
      {'<leader>sg', function() require('telescope.builtin').live_grep() end, { desc = '[S]earch by [G]rep' }},
      {'<leader>sd', function() require('telescope.builtin').diagnostics() end, { desc = '[S]earch [D]iagnostics' }},
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    },
    config = function ()
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
    end
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
        add          = { hl = 'GitSignsAdd', text = "▎", numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = "▎", numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = "契", numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = "契", numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        untracked    = { hl = 'GitSignsAdd', text = "▎", numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
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
    'numToStr/Comment.nvim',-- "gc" to comment visual regions/lines
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  {
    'tpope/vim-sleuth',-- Detect tabstop and shiftwidth automatically
    event = { "BufReadPost", "BufNewFile" }
  },

  {
    "windwp/nvim-spectre",
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "[S]earch and [R]eplace globaly" },
    },
  },
}

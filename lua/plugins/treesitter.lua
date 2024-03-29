return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'bash',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'rust',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      },
      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
      autotag = { enable = true },
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-backspace>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
    dependencies = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          patterns = {
            -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
              'class',
              'function',
              'method',
              'for',
              'while',
              'if',
              'switch',
              'case',
              'interface',
              'struct',
              'enum',
            },
            -- Patterns for specific filetypes
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            tex = {
              'chapter',
              'section',
              'subsection',
              'subsubsection',
            },
            haskell = {
              'adt',
            },
            rust = {
              'impl_item',
            },
            terraform = {
              'block',
              'object_elem',
              'attribute',
            },
            scala = {
              'object_definition',
            },
            vhdl = {
              'process_statement',
              'architecture_body',
              'entity_declaration',
            },
            markdown = {
              'section',
            },
            elixir = {
              'anonymous_function',
              'arguments',
              'block',
              'do_block',
              'list',
              'map',
              'tuple',
              'quoted_content',
            },
            json = {
              'pair',
            },
            typescript = {
              'export_statement',
            },
            yaml = {
              'block_mapping_pair',
            },
          },
          exact_patterns = {
            -- Example for a specific filetype with Lua patterns
            -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
            -- exactly match "impl_item" only)
            -- rust = true,
          },
          -- [!] The options below are exposed but shouldn't require your attention,
          --     you can safely ignore them.

          zindex = 20, -- The Z-index of the context window
          mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
        },
      },
    },
  },
}

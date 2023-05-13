return {
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = function()
			return {
				style = "night",
				-- transparent = true,
				-- styles = {
				--   sidebars = "transparent",
				--   floats = "transparent",
				-- },
				sidebars = {
					"qf",
					"vista_kind",
					"terminal",
					"spectre_panel",
					"startuptime",
					"Outline",
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
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	{ 'nvim-tree/nvim-web-devicons', lazy = true },

	-- Winbar
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-web-devicons",
		},
		config = true
	},
	{
		'norcalli/nvim-colorizer.lua',
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require('colorizer').setup()
		end
	},
	-- Fancy statusline
	{
		'nvim-lualine/lualine.nvim',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-web-devicons" },
		opts = function()
			local custom_fname = require('lualine.components.filename'):extend()
			local highlight = require 'lualine.highlight'
			local default_status_colors = { saved = '#242b38', modified = '#730808', fg = '#fcfcfc' }

			function custom_fname:init(options)
				custom_fname.super.init(self, options)
				self.status_colors = {
					saved = highlight.create_component_highlight_group(
						{ bg = default_status_colors.saved, fg = default_status_colors.fg },
						'filename_status_saved', self.options),
					modified = highlight.create_component_highlight_group(
						{ bg = default_status_colors.modified, fg = default_status_colors.fg },
						'filename_status_modified', self.options),
				}
				if self.options.color == nil then self.options.color = '' end
			end

			function custom_fname:update_status()
				local data = custom_fname.super.update_status(self)
				data = highlight.component_format_highlight(vim.bo.modified
					    and self.status_colors.modified
					    or self.status_colors.saved) .. data
				return data
			end

			return {
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
					lualine_b = { custom_fname },
					lualine_c = { 'branch', 'diff', 'diagnostics' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_ = {},
					lualine_b = { custom_fname },
					lualine_c = {},
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		end
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			buftype_exclude = {
				"nofile",
				"terminal",
			},
			filetype_exclude = {
				"help",
				"startify",
				"aerial",
				"alpha",
				"dashboard",
				"lazy",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
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
			char = "▏",
			context_char = "▏",
			show_current_context = true,
		},
	},
	{
		'stevearc/dressing.nvim',
		event = { "BufReadPre", "BufNewFile" },
		config = true
	},
}

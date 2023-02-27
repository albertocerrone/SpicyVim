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
	-- Fancy statusline
	{
		'nvim-lualine/lualine.nvim',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-web-devicons" },
		opts = {
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
				lualine_ = {},
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
		'stevearc/dressing.nvim',
		event = { "BufReadPre", "BufNewFile" },
		config = true
	},
}

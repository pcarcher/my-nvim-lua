-- lua/plugins/ui.lua
return {
	-- Lualine statusline
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				theme = "auto",
				icons_enabled = true,
				component_separators = "",
				section_separators = "",
				options = {
					disabled_filetypes = { "undotree", "diffview", "neo-tree", "lir" },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { "filename", "diff", "diagnostics" },
					lualine_x = { "filetype", "encoding", "fileformat" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
				},
				tabline = {
					lualine_a = { "buffers" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "tabs" },
				},
				extensions = { "fzf", "quickfix" },
			})
		end,
	},

	-- Icons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	}, -- Cursorline
	{
		"yamatsum/nvim-cursorline",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-cursorline").setup({
				cursorline = { enable = true, timeout = 1000, number = false },
				cursorword = {
					enable = true,
					min_length = 3,
					hl = { underline = true },
				},
			})
		end,
	}, -- Animate
	{ "camspiers/animate.vim", lazy = false }, -- Lens (auto-resize windows)
	{
		"echasnovski/mini.icons",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	}, -- Mini Statusline
}

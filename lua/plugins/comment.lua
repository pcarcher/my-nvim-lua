-- lua/plugins/kommentary.lua
return {
	{
		"b3nj5m1n/kommentary",
		lazy = false,
		init = function()
			vim.g.kommentary_create_default_mappings = false
		end,
		config = function()
			local map = vim.keymap.set

			map("n", "<leader>/", "<Plug>kommentary_line_default")
			map("n", "<leader>c", "<Plug>kommentary_motion_default")

			map("n", "<leader>cic", "<Plug>kommentary_line_increase")
			map("n", "<leader>ci", "<Plug>kommentary_motion_increase")
			map("x", "<leader>ci", "<Plug>kommentary_visual_increase")

			map("n", "<leader>cdc", "<Plug>kommentary_line_decrease")
			map("n", "<leader>cd", "<Plug>kommentary_motion_decrease")
			map("x", "<leader>cd", "<Plug>kommentary_visual_decrease")

			require("kommentary.config").configure_language("typescript", {
				single_line_comment_string = "//",
				multi_line_comment_strings = { "{/*", "*/}" },
				prefer_single_line_comments = true,
			})
		end,
	},
}


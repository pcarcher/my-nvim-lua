-- lua/plugins/kommentary.lua
return {
	{
		"b3nj5m1n/kommentary",
		lazy = false,
		init = function()
			vim.g.kommentary_create_default_mappings = false
		end,
		keys = {
			{
				"<leader>c",
				group = "Comment",
				mode = { "n", "x" },
			},
			{ "<leader>/", "<Plug>kommentary_line_default", mode = "n", desc = "Comment line" },
			{ "<leader>c", "<Plug>kommentary_motion_default", mode = "n", desc = "Comment motion" },
			{ "<leader>cic", "<Plug>kommentary_line_increase", mode = "n", desc = "Comment line increase" },
			{ "<leader>ci", "<Plug>kommentary_motion_increase", mode = { "n", "x" }, desc = "Comment motion increase" },
			{ "<leader>cdc", "<Plug>kommentary_line_decrease", mode = "n", desc = "Comment line decrease" },
			{ "<leader>cd", "<Plug>kommentary_motion_decrease", mode = { "n", "x" }, desc = "Comment motion decrease" },
		},
		config = function()
			require("kommentary.config").configure_language("typescript", {
				single_line_comment_string = "//",
				multi_line_comment_strings = { "{/*", "*/}" },
				prefer_single_line_comments = true,
			})
		end,
	},
}

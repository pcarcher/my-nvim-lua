return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>X",
			group = "Trouble",
			mode = { "n", "x" },
			desc = "Open Trouble",
		},
		{ "<leader>Xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Document Diagnostics Toggle" },
		{
			"<leader>Xq",
			"<cmd>Trouble quickfix<cr>",
			desc = "Open Trouble QuickFix",
		},
		{
			"<leader>Xs",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>Xl",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Open Trouble LocationList",
		},
		{
			"<leader>Xa",
			"<cmd>Trouble diagnostics<cr>",
			desc = "Open Trouble Document Diagnostics",
		},
		modes = {
			preview_float = {
				mode = "diagnostics",
				preview = {
					type = "float",
					relative = "editor",
					border = "rounded",
					title = "Preview",
					title_pos = "center",
					position = { 0, -2 },
					size = { width = 0.3, height = 0.3 },
					zindex = 200,
				},
			},
		},
	},
}

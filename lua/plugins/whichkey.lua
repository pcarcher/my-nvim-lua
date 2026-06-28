return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				preset = "modern", -- o "classic" / "helix"
				plugins = {
					marks = false,
					registers = false,
					spelling = { enabled = false, suggestions = 20 },
				},
			})
			-- Keymaps
			vim.keymap.set("n", "<leader>t", "<cmd>WhichKey<CR>", { desc = "Show WhichKey" })
			vim.keymap.set("n", "<leader>tf", "<cmd>WhichKey <leader><CR>", { desc = "Show Leader mappings" })
		end,
	},
}


-- lua/plugins/treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.10.0",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"html",
					"css",
					"vue",
					"svelte",
				},
				sync_install = false,
				highlight = {
					enable = true,
					use_languagetree = true,
				},
				indent = { enable = false },
			})
		end,
	},
}

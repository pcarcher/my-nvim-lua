return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		local ufo = require("ufo")

		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})

		-- Open all folds
		vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })

		-- -- Close all folds
		vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })

		-- Open one level of folding
		vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open one level of folds" })

		-- Close one level of folding
		vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close one level of folds" })

		-- Toggle current fold
		-- Standard Neovim behavior, works perfectly with ufo
		vim.keymap.set("n", "za", "za", { desc = "Toggle current fold" })

		-- Extra: Peek fold or LSP Hover
		-- Shows the content of a closed fold in a floating window
		vim.keymap.set("n", "K", function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover() -- Fallback to normal LSP hover if not on a fold
			end
		end, { desc = "Peek fold or LSP Hover" })
	end,
}

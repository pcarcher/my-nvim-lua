return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm" },
		keys = {
			{ "<F12>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
		},
		shell = "/bin/zsh",
		config = function()
			-- Función global para keymaps en terminal
			function _G.set_terminal_keymaps()
				local opts = { noremap = true }
				local buf_map = vim.api.nvim_buf_set_keymap

				buf_map(0, "t", "<esc>", [[<C-\><C-n>]], opts)
				buf_map(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
				buf_map(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
				buf_map(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
				buf_map(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
			end

			vim.cmd([[
        augroup ToggleTermKeymaps
          autocmd!
          autocmd TermOpen term://*toggleterm#* lua set_terminal_keymaps()
        augroup END
      ]])

			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 10 -- alto fijo (líneas)
					elseif term.direction == "vertical" then
						return 40 -- ancho fijo (columnas)
					end
					return 20
				end,
				open_mapping = [[<F12>]],
				direction = "float", -- horizontal | vertical | window | float
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				close_on_exit = true,
				shell = vim.o.shell,
				shade_filetypes = {},
				shade_terminals = false,
				shading_factor = 1,
				highlights = {
					Normal = { link = "Normal" },
					NormalFloat = { link = "Normal" },
					FloatBorder = { link = "FloatBorder" },
				},
				float_opts = {
					border = "curved",
					width = 150, -- ancho fijo
					height = 40, -- alto fijo
					winblend = 4,
				},
				winbar = { enabled = true },
			})
		end,
	},
}

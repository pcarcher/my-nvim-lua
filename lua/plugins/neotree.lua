return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = false, -- No cerrar si es la última ventana abierta
			filesystem = {
				follow_current_file = {
					enabled = true, -- El árbol sigue al archivo que tienes abierto
					leave_dirs_open = true, -- No cierra las carpetas al cambiar de archivo
				},
				hijack_netrw_behavior = "open_default",
				use_libuv_file_watcher = true, -- Auto-refresca cuando cambias archivos fuera de nvim
				-- MOSTRAR ARCHIVOS OCULTOS
				filtered_items = {
					visible = true, -- muestra también lo filtrado
					hide_dotfiles = false, -- NO ocultar archivos que empiezan con .
					hide_gitignored = false, -- NO ocultar lo ignorado por git
				},
			},
			window = {
				width = 35,
				mappings = {
					["<space>"] = "none", -- Desactiva el espacio para que no interfiera con tu leader
				},
			},
		})

		-- KEYMAP: <leader>e para abrir y "revelar" el archivo actual
		vim.keymap.set("n", "<leader>e", function()
			-- "reveal" hace que el árbol se abra y ponga el foco en el archivo que estás editando
			vim.cmd("Neotree reveal left")
		end, { desc = "Neo-tree reveal current file" })

		-- KEYMAP: <C-b> para cerrar/abrir (Toggle) como en VS Code
		vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Explorer" })
	end,
}


return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "folke/trouble.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- acción custom para quickfix -> trouble
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-f>"] = trouble_telescope.open, -- en el picker, sigue siendo Trouble
					},
				},
			},
			pickers = {
				find_files = {
					theme = "dropdown",
					previewer = false,
				},
			},
			extensions = {
				file_browser = {
					theme = "dropdown",
					previewer = false,
					hijack_netrw = true,
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")

		local keymap = vim.keymap

		-- Abre un “árbol”/explorador de archivos en panel tipo lateral con <C-f>
		keymap.set("n", "<C-f>", function()
			telescope.extensions.file_browser.file_browser({
				path = vim.loop.cwd(),
				cwd = vim.loop.cwd(),
				grouped = true,
				hidden = true,
				respect_gitignore = false,
				initial_mode = "normal",
				layout_strategy = "vertical",
				layout_config = {
					width = 0.4, -- panel “izquierdo”
					height = 0.95,
					prompt_position = "top",
				},
			})
		end, { desc = "Telescope file browser (tree-like)" })

		-- tus keymaps existentes
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
	end,
}


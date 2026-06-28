-- lua/plugins/neotest.lua
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim", -- Recomendado para mejor performance
			"nvim-neotest/nvim-nio", -- Requerido en versiones recientes

			-- Adaptadores
			"nvim-neotest/neotest-python", -- Python
			"rouge8/neotest-rust", -- Rust
			"nvim-neotest/neotest-jest", -- Jest (TS/JS)
			"marilari88/neotest-vitest", -- Vitest (TS/JS)
		},
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run file tests",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle test summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Show test output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle output panel",
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG" },
						runner = "pytest", -- o "unittest"
					}),
					require("neotest-rust")({
						args = { "--no-capture" },
					}),
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "custom.jest.config.ts",
						env = { CI = true },
						cwd = function(path)
							return vim.fn.getcwd()
						end,
					}),
					require("neotest-vitest"),
				},
				-- Configuración general
				discovery = {
					enabled = true,
				},
				diagnostic = {
					enabled = true,
				},
				floating = {
					border = "rounded",
					max_height = 0.6,
					max_width = 0.6,
				},
				icons = {
					running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
				},
				output = {
					open_on_run = true,
				},
				quickfix = {
					enabled = true,
					open = false,
				},
				status = {
					enabled = true,
					virtual_text = true,
					signs = true,
				},
				strategies = {
					integrated = {
						width = 120,
						height = 40,
					},
				},
			})
		end,
	},
}

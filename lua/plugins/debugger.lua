return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{
			"<leader>D",
			group = "Debugger",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Run/Continue",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Dsi",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step into",
			nowait = true,
			remap = false,
		},
		{
			"<leader>DsO",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step over",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Dso",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step out",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle breakpoint",
			nowait = true,
			remap = false,
		},
		{
			"<leader>DB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: set conditional breakpoint",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run last Configuration",
			nowait = true,
			remap = false,
		},
		{
			"<leader>Dq",
			function()
				require("dap").close()
				require("dapui").close()
				require("nvim-dap-virtual-text").close()
			end,
			desc = "Debug: Close",
			noremap = true,
			remap = false,
		},
		{
			"<leader>DL",
			function()
				require("dap").list_breakpoints()
			end,
			desc = "Debug: List breakpoints",
			nowait = true,
			remap = false,
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "⏪",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		require("nvim-dap-virtual-text").setup()

		dap.configurations.rust = {
			{
				name = "Rust: Custom Launch",
				type = "codelldb",
				request = "launch",
				program = function()
					vim.fn.jobstart("cargo build")
					return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				console = "integratedTerminal",
			},
		}

		dap.configurations.javascript = {
			{
				name = "Launch File",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
			{
				name = "Attach to Process",
				type = "node2",
				request = "attach",
				processId = require("dap.utils").pick_process,
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
			},
		}

		dap.configurations.python = {
			{
				name = "Launch File",
				type = "debugpy",
				request = "launch",
				program = "${file}",
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					end

					-- Busca .venv en el proyecto
					if vim.fn.executable(vim.fn.getcwd() .. "/.venv/bin/python") == 1 then
						return vim.fn.getcwd() .. "/.venv/bin/python"
					end
					if vim.fn.executable(vim.fn.getcwd() .. "/venv/bin/python") == 1 then
						return vim.fn.getcwd() .. "/venv/bin/python"
					end

					return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
				end,
				console = "integratedTerminal",
				justMyCode = true,
			},
			{
				name = "Launch with Args",
				type = "debugpy",
				request = "launch",
				program = "${file}",
				args = function()
					local args = vim.fn.input("Arguments: ")
					return vim.split(args, " ")
				end,
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					end
					if vim.fn.executable(vim.fn.getcwd() .. "/.venv/bin/python") == 1 then
						return vim.fn.getcwd() .. "/.venv/bin/python"
					end
					return vim.fn.exepath("python3") or "python"
				end,
				console = "integratedTerminal",
				justMyCode = true,
			},
			{
				name = "Attach to Process",
				type = "debugpy",
				request = "attach",
				processId = require("dap.utils").pick_process,
				pythonPath = function()
					return vim.fn.exepath("python3") or "python"
				end,
			},
			{
				name = "Django",
				type = "debugpy",
				request = "launch",
				program = vim.fn.getcwd() .. "/manage.py",
				args = { "runserver", "--noreload" },
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					end
					if vim.fn.executable(vim.fn.getcwd() .. "/.venv/bin/python") == 1 then
						return vim.fn.getcwd() .. "/.venv/bin/python"
					end
					return vim.fn.exepath("python3") or "python"
				end,
				console = "integratedTerminal",
				justMyCode = true,
				django = true,
			},
		}

		dap.configurations.typescript = dap.configurations.javascript
	end,
}

return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"pyright",
				"eslint",
				"dockerls",
				"bashls",
				"sqlls",
				"rust_analyzer",
				"jsonls",
				"gitlab_ci_ls",
				"gopls",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function(_, opts)
			require("mason-lspconfig").setup({
				ensure_installed = opts.ensure_installed,
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					-- Rust
					["rust_analyzer"] = function()
						require("lspconfig").rust_analyzer.setup({
							settings = {
								["rust-analyzer"] = {
									cargo = { allFeatures = true },
									check = { command = "clippy" },
									diagnostics = { enable = true },
								},
							},
						})
					end,
					-- TypeScript/JavaScript
					["ts_ls"] = function()
						require("lspconfig").ts_ls.setup({
							settings = {
								typescript = {
									inlayHints = {
										includeInlayParameterNameHints = "all",
										includeInlayFunctionParameterTypeHints = true,
									},
								},
							},
						})
					end,

					-- Lua
					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							settings = {
								Lua = {
									format = { enable = true },
									diagnostics = { globals = { "vim" } },
									workspace = { checkThirdParty = false },
									telemetry = { enable = false },
								},
							},
						})
					end,

					-- Emmet
					["emmet_ls"] = function()
						require("lspconfig").emmet_ls.setup({
							filetypes = {
								"html",
								"css",
								"scss",
								"javascript",
								"javascriptreact",
								"typescript",
								"typescriptreact",
							},
						})
					end,

					-- Tailwind
					["tailwindcss"] = function()
						require("lspconfig").tailwindcss.setup({
							settings = {
								tailwindCSS = {
									experimental = {
										classRegex = {
											{
												"cva\\(([^)]*)\\)",
												"[\"'`]([^\"'`]*).*?[\"'`]",
											},
											{
												"cx\\(([^)]*)\\)",
												"(?:'|\"|`)([^']*)(?:'|\"|`)",
											},
										},
									},
								},
							},
						})
					end,

					-- ESLint
					["eslint"] = function()
						require("lspconfig").eslint.setup({
							settings = { workingDirectory = { mode = "auto" } },
							on_attach = function(client, bufnr)
								vim.api.nvim_create_autocmd("BufWritePre", {
									buffer = bufnr,
									command = "EslintFixAll",
								})
							end,
						})
					end,

					-- JSON
					["jsonls"] = function()
						require("lspconfig").jsonls.setup({
							settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							},
						})
					end,

					-- Python
					["pyright"] = function()
						require("lspconfig").pyright.setup({
							settings = {
								python = {
									analysis = {
										autoImportCompletions = true,
										typeCheckingMode = "basic", -- Puede ser "off", "basic" o "strict"
										diagnosticMode = "workspace",
										useLibraryCodeForTypes = true,
										autoSearchPaths = true,

										-- Desactiva los reportes molestos
										-- 🔥 DESACTIVA EXPLÍCITAMENTE
										reportOptionalMemberAccess = false,
										reportAttributeAccessIssue = false,
										reportGeneralTypeIssues = false,
										reportUnknownMemberType = false,
										reportUnknownVariableType = false,
										reportUnknownParameterType = false,
									},
								},
							},
							on_init = function(client)
								if client.config.settings then
									client.config.settings.python.pythonPath = vim.fn.exepath("python3")
								end
							end,
						})
					end,

					["sqlls"] = function()
						require("lspconfig").sqlls.setup({
							cmd = {
								"sql-language-server",
								"up",
								"--method",
								"stdio",
							},
							filetypes = { "sql", "mysql", "plsql" },
							root_dir = require("lspconfig").util.root_pattern(
								".git",
								"package.json",
								"setup.py",
								"setup.cfg",
								"pyproject.toml",
								"requirements.txt",
								"Makefile",
								"docker-compose.yml",
								"docker-compose.yaml",
								"dockerfile"
							) or vim.loop.cwd(),
							settings = {
								sqlLanguageServer = {
									lint = {
										-- activa/desactiva reglas de linting
										ambiguousColumn = true,
										ambiguousFunction = true,
										ambiguousGroupBy = true,
										caseSensitive = true,
										columnAlias = true,
										duplicateColumn = true,
										keyword = true,
										leadingWildcard = true,
										nullComparison = true,
										orderBy = true,
										secureFunction = true,
										union = true,
										unusedCte = true,
										unusedSubquery = true,
									},
									-- puedes personalizar dialecto si tu versión del server lo soporta
									-- dialect = "mysql" | "postgresql" | "sqlserver" | "sqlite"
								},
							},
						})
					end,

					["dockerls"] = function()
						require("lspconfig").dockerls.setup({
							settings = {
								docker = {
									languageserver = {
										formatter = {
											ignoreMultilineInstructions = true, -- No formatea instrucciones multilínea
										},
										diagnostics = {
											-- Nivel de severidad para diagnósticos
											deprecatedMaintainer = "warning",
											directiveCasing = "warning",
											emptyContinuationLine = "warning",
											instructionCasing = "warning", -- Advertencia si usas minúsculas en FROM, RUN, etc.
											instructionCmdMultiple = "warning",
											instructionEntrypointMultiple = "warning",
											instructionHealthcheckMultiple = "warning",
											instructionJSONInSingleQuotes = "warning",
											instructionWorkdirRelative = "warning",
										},
									},
								},
							},
						})
					end,

					["gitlab_ci_ls"] = function()
						require("lspconfig").gitlab_ci_ls.setup({})
					end,

					["gopls"] = function()
						require("lspconfig").gopls.setup({
							filetypes = { "go", "gomod", "gohtmltmpl", "gotexttmpl" },
							root_markers = { "go.work", "go.mod", ".git" },
							cmd = {
								"gopls", -- share the gopls instance if there is one already
								"-remote=auto", --[[ debug options ]] --
								-- "-logfile=auto",
								-- "-debug=:0",
								"-remote.debug=:0",
								-- "-rpc.trace",
							},
							settings = {
								gopls = {
									-- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
									-- not supported
									analyses = { unusedparams = true, unreachable = false },
									codelenses = {
										generate = true, -- show the `go generate` lens.
										gc_details = true, --  // Show a code lens toggling the display of gc's choices.
										test = true,
										tidy = true,
									},
									usePlaceholders = true,
									completeUnimported = true,
									staticcheck = true,
									matcher = "fuzzy",
									diagnosticsDelay = "500ms",
									symbolMatcher = "fuzzy",
									gofumpt = false, -- true, -- turn on for new repos, gofmpt is good but also create code turmoils
									buildFlags = { "-tags", "integration" },
									-- buildFlags = {"-tags", "functional"}
									semanticTokens = false,
								},
							},
						})
					end,
				},
			})

			require("mason-nvim-dap").setup({
				ensure_installed = {
					"python",
					"cpptools",
					"codelldb",
					"node-debug2-adapter",
					"php-debug-adapter",
					"bash-debug-adapter",
				},
				automatic_installation = true,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
				"shfmt",
			},
		},
		dependencies = { "williamboman/mason.nvim" },
	},
}

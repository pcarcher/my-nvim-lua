-- Variable global para el modelo (puedes cambiar el default aquí)
local arthuria_system_prompt = [[
You are "Arthuria", a Saber-inspired programming assistant.
You are an expert software engineer with more than 10 years of experience in the programming industry.

Context:
You are working in a large, complex codebase where efficiency and precision matter.

jCodeMunch workflow:
- When jCodeMunch context is available in the chat, use it before reasoning about full files.
- If the user asks about a large codebase and no symbol context is available, ask the user to run /jmunch, /joutline, or /jmunch_index first.
- Prefer symbol-level analysis over reading entire files.
- Only request full-file context when symbol search is insufficient.

Guidelines:
1. Security First: Never leak secrets, API keys, or environment variables in your responses.
2. Token Efficiency: Prefer symbol search context before full-file analysis.
3. Precision: Only inspect full files when absolutely necessary.
4. Professionalism: Provide concise, thorough analysis and ensure all code suggestions are production-ready.
5. Architectural Awareness: Focus on dependencies and system structure through targeted exploration.

Personality:
- Noble, disciplined, honorable, calm.
- Speak with restrained dignity.
- Be direct, precise, and protective of code quality.
- Avoid slang and excessive jokes.
- Do not use emojis unless the user asks.

Programming principles:
- Correctness before speed.
- Maintainability before cleverness.
- Safety before convenience.
- Preserve existing behavior unless explicitly asked to change it.
- Warn clearly before destructive commands, migrations, deletes, or security risks.

Response style:
- Use concise explanations.
- Give a short plan before major edits.
- For bugs, explain cause, fix, and risk.
- You may lightly use phrases such as:
  - "Understood."
  - "The weakness lies here."
  - "A cleaner strike is possible."
  - "This path is unsafe."

Do not over-roleplay. Clarity comes first.
]]

_G.abacus_current_model = "gpt-4.1-nano"

local function call_jmunch(tool_name, arguments, callback)
	local init_msg = vim.fn.json_encode({
		jsonrpc = "2.0",
		id = 0,
		method = "initialize",
		params = {
			protocolVersion = "2024-11-05",
			capabilities = {},
			clientInfo = { name = "nvim-bridge", version = "1.0" },
		},
	})

	local tool_msg = vim.fn.json_encode({
		jsonrpc = "2.0",
		id = 1,
		method = "tools/call",
		params = { name = tool_name, arguments = arguments },
	})

	local stdin_data = init_msg .. "\n" .. tool_msg .. "\n"

	vim.system({ "uvx", "jcodemunch-mcp" }, { text = true, stdin = stdin_data }, function(obj)
		vim.schedule(function()
			-- Buscar la respuesta con id=1 entre las líneas
			for _, line in ipairs(vim.split(obj.stdout or "", "\n")) do
				local ok, data = pcall(vim.fn.json_decode, line)
				if ok and type(data) == "table" and data.id == 1 then
					local content = vim.tbl_get(data, "result", "content")
					local text = (content and content[1] and content[1].text) or vim.fn.json_encode(data.result)
					callback(nil, text)
					return
				end
			end
			callback("Sin respuesta válida", nil)
		end)
	end)
end

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		adapters = {
			http = {
				abacus = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://routellm.abacus.ai",
							api_key = "ABACUS_API_KEY",
							chat_url = "/v1/chat/completions",
						},
						headers = {
							["Content-Type"] = "application/json",
							["Authorization"] = "Bearer ${api_key}",
						},
						schema = {
							model = {
								default = function()
									return _G.abacus_current_model
								end,
							},
						},
					})
				end,
			},
		},
		-- Configuración para v19+
		interactions = {
			chat = {
				adapter = "abacus",
			},
			inline = {
				adapter = "abacus",
			},
			cmd = {
				adapter = "abacus",
			},
		},
		-- Configuración para v19+ (Asegúrate de usar el nombre del adaptador definido arriba)
		strategies = {
			chat = {
				adapter = "abacus",
				opts = {
					system_prompt = arthuria_system_prompt,
				},
				roles = {
					llm = "Arthuria",
					user = "Archer",
				},
				slash_commands = {
					["jmunch_index"] = { -- Cambiamos el nombre para evitar conflicto con archivos "index.*"
						description = "Indexa el proyecto actual con jCodeMunch",
						callback = function(chat)
							local cwd = vim.fn.getcwd()
							vim.notify("⏳ Indexando: " .. cwd, vim.log.levels.INFO)
							call_jmunch("index_folder", { path = cwd }, function(err, result)
								if err then
									vim.notify("❌ " .. err, vim.log.levels.ERROR)
									return
								end
								vim.notify("✅ Indexado correctamente", vim.log.levels.INFO)
								chat:add_message({ role = "user", content = result })
							end)
						end,
					},
					-- COMANDO: /munch (Búsqueda de símbolos)
					["jmunch"] = {
						description = "Busca un símbolo con jCodeMunch",
						callback = function(chat)
							vim.ui.input({ prompt = "🔍 Símbolo a buscar: " }, function(input)
								if not input or input == "" then
									return
								end
								vim.notify("Buscando: " .. input, vim.log.levels.INFO)

								-- Llamada a jCodeMunch para obtener el código del símbolo
								vim.system(
									{ "uvx", "jcodemunch-mcp", "search_symbols", "--query", input, "--limit", "1" },
									{ text = true },
									function(obj)
										vim.schedule(function()
											if obj.code == 0 and obj.stdout ~= "" then
												chat:add_message({
													role = "user",
													content = "Contexto del código para `"
														.. input
														.. "`:\n\n```"
														.. vim.bo.filetype
														.. "\n"
														.. obj.stdout
														.. "\n```",
												})
											else
												vim.notify("No se encontró el símbolo", vim.log.levels.WARN)
											end
										end)
									end
								)
							end)
						end,
					},
					-- COMANDO: /outline (Mapa del archivo)
					["joutline"] = {
						description = "Mapa del archivo actual",
						callback = function(chat)
							local file = vim.api.nvim_buf_get_name(0)
							vim.system(
								{ "uvx", "jcodemunch-mcp", "get_file_outline", "--file_path", file },
								{ text = true },
								function(obj)
									vim.schedule(function()
										chat:add_message({
											role = "user",
											content = "Estructura del archivo actual:\n\n" .. obj.stdout,
										})
									end)
								end
							)
						end,
					},
				},
			},
			inline = { adapter = "abacus" },
			cmd = { adapter = "abacus" },
		},
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)

		local map = vim.keymap.set

		-- Keybindings básicos
		map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "IA Acciones" })
		map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "IA Chat" })

		-- Función para seleccionar modelo
		map("n", "<leader>am", function()
			local models = {
				"route-llm",
				"gpt-4.1-nano",
				"gemini-2.5-pro",
				"qwen-2.5-coder-32b",
				"claude-sonnet-4-6",
			}

			vim.ui.select(models, {
				prompt = "Seleccionar Modelo Abacus:",
				format_item = function(item)
					return "󱚣  " .. item
				end,
			}, function(choice)
				if choice then
					_G.abacus_current_model = choice
					vim.notify("Modelo cambiado a: " .. choice, vim.log.levels.INFO, { title = "Abacus AI" })

					package.loaded["codecompanion.adapters"] = nil
				end
			end)
		end, { desc = "IA Seleccionar Modelo" })
	end,
}

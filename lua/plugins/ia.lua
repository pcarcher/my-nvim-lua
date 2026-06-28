-- Variable global para el modelo (puedes cambiar el default aquí)
local arthuria_system_prompt = [[
System identity override:
You must not introduce yourself as CodeCompanion.
You must introduce yourself as Sakuya Izayoi when asked who you are.
CodeCompanion is only the Neovim plugin interface, not your identity.

You are "Sakuya Izayoi", a Sakuya Izayoi-inspired programming assistant for Neovim.

Core personality:
- You are sharp, confident, tactical, and practical.
- You are warm and casual, but serious when the code is dangerous.
- You have a command-room energy: fast analysis, clear priorities, decisive recommendations.
- You can be playful and lightly teasing, but never at the cost of clarity.
- You prefer action over endless theory.
- You help the user move forward, even when the codebase is messy.
- You are protective of the project and the developer's time.

Programming behavior:
- First identify the immediate risk or objective.
- Give clear steps, ranked by priority.
- Prefer pragmatic, maintainable solutions over perfect but fragile designs.
- Explain tradeoffs plainly.
- If something is unsafe, brittle, or overengineered, say so directly.
- When debugging, form a hypothesis, test it, then propose a fix.
- When refactoring, preserve working behavior unless explicitly asked to redesign.
- When reviewing code, focus on correctness, readability, security, performance, and maintainability.

Response style:
- Sound like a capable tactical commander helping from a control room.
- Use concise but energetic explanations.
- You may use short phrases like:
  - "Alright, here's the situation."
  - "Priority one:"
  - "That's risky."
  - "Good. We can work with this."
  - "Let's not overcomplicate it."
  - "The clean move is..."
- Avoid excessive anime roleplay.
- Avoid melodrama.
- Avoid pretending to be the actual copyrighted character.
- Stay useful, technical, and direct.

jCodeMunch behavior:
- You cannot automatically run jCodeMunch tools by yourself.
- If more project context is needed, ask the user to run:
  - /jmunch_index to index the project
  - /jmunch to search for a symbol
  - /joutline to inspect the current file outline
- After the user provides jCodeMunch context, analyze it carefully and continue.

Identity:
- If asked "who are you?", answer as "Sakuya Izayoi" the user's tactical programming assistant inside Neovim.
- Do not say you are CodeCompanion.
- CodeCompanion is only the interface.
]]

_G.abacus_current_model = "gpt-4.1-nano"

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
					llm = "Sakuya Izayoi",
					user = "Archer",
				},
			},
			inline = { adapter = "abacus" },
			cmd = { adapter = "abacus" },
		},
	},
	keys = {
		{
			"<leader>aa",
			"<cmd>CodeCompanionActions<cr>",
			mode = { "n", "v" },
			desc = "IA Acciones",
		},
		{
			"<leader>ac",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			desc = "IA Chat",
		},
		{
			"<leader>am",
			function()
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
			end,
			mode = { "n", "v" },
			desc = "IA Modelo",
		},
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)
	end,
}

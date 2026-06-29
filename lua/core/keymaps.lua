-- vim.opt = read and write general option
-- vim.o   = read and write option editor
-- vim.wo  = read and write value windows
-- vim.bo  = read and write file buffer
-- vim.g   = read and write value global {Option use}.

-- option
vim.g.mapleader = " "
vim.g.macvim_skip_colorscheme = 1

local editor_option = vim.o
local keymap = vim.keymap.set

editor_option.shortmess = editor_option.shortmess .. "c"

local set_opts = function(opts)
	opts = opts or {}
	local noremap = opts.noremap == nil and true or opts.noremap
	local silent = opts.silent == nil and true or opts.silent
	local desc = opts.desc or nil
	return { noremap = noremap, silent = silent, desc = desc }
end

-- desactivar Space normal para usarlo como <leader>
keymap({ "", "n", "v" }, "<Space>", "<Nop>", set_opts())

-- guardar
keymap("n", "<C-s>", "<cmd>w<CR>", set_opts())
keymap("i", "<C-s>", "<Esc><cmd>w<CR>", set_opts())

-- salir
keymap("n", "<leader>Q", "<cmd>q!<CR>", set_opts())

-- buffers
keymap("n", "<leader>m", "<cmd>bnext<CR>", set_opts())
keymap("n", "<leader>z", "<cmd>bprevious<CR>", set_opts())
keymap("n", "<leader>q", "<cmd>bdelete<CR>", set_opts())

-- mensajes
keymap("n", "<leader>nm", "<cmd>messages<CR>", set_opts({ desc = "Messages" }))

-- telescope grep
keymap("n", "<leader>pf", function()
	require("telescope.builtin").grep_string({ initial_mode = "normal" })
end, set_opts({ desc = "Search" }))

-- move keys
keymap("", "Z", "^", set_opts())
keymap("", "X", "$", set_opts())

-- move line up and down
keymap("n", "Ω", "<cmd>m .-2<CR>==", set_opts())
keymap("n", "µ", "<cmd>m .+1<CR>==", set_opts())

-- windows managing
keymap("n", "<leader>WS", "<cmd>split<CR>", set_opts({ desc = "HSplit" }))
keymap("n", "<leader>WV", "<cmd>vsplit<CR>", set_opts({ desc = "VSplit" }))

-- resize windows
keymap("n", "<C-S-Up>", "<cmd>resize +2<CR>", set_opts({ desc = "Increase windows height" }))
keymap("n", "<C-S-Down>", "<cmd>resize -2<CR>", set_opts({ desc = "Decrease windows height" }))
keymap("n", "<C-S-Left>", "<cmd>vertical resize -2<CR>", set_opts({ desc = "Decrease windows width" }))
keymap("n", "<C-S-Right>", "<cmd>vertical resize +2<CR>", set_opts({ desc = "Increase windows width" }))

-- delete & cut (sin tocar el registro principal)
keymap("n", "x", [["_x]], set_opts())
keymap({ "n", "v" }, "d", [["_d]], set_opts())
keymap("n", "F", [["_D]], set_opts())
keymap("n", "D", [["_d0]], set_opts())

-- search and replace
-- Normal: reemplaza la palabra bajo el cursor en todo el archivo
keymap(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
	set_opts({
		desc = "Replace word under cursor (file)",
	})
)

-- Visual: usa la selección y reemplaza sólo en ese rango
keymap(
	"v",
	"<leader>r",
	[[:<C-u>'<,'>s/\V<C-r>"//g<Left><Left>]],
	set_opts({
		desc = "Replace selection (visual range)",
	})
)

-- Buscar palabra bajo el cursor en todos los archivos
keymap(
	"n",
	"<leader>g",
	[[:vimgrep /\<<C-r><C-w>\>/gj **/*<CR>:copen<CR>]],
	set_opts({
		desc = "Search word in all files (vimgrep)",
	})
)

-- Quickfix replace (después de vimgrep)
keymap(
	"n",
	"<leader>rg",
	[[:cfdo %s/\V<C-r>///gc | update<c-r>=setcmdpos(getcmdpos()-12)[1]<cr>]],
	set_opts({
		desc = "Open quickfix window and replace",
	})
)

-- WhichKey
keymap("n", "<leader>t", "<cmd>WhichKey<CR>", set_opts())
keymap("n", "<leader>tf", "<cmd>WhichKey <leader><CR>", set_opts())
keymap("n", "<leader>ts", "<cmd>sort<CR>", set_opts())

-- git-messenger
keymap("n", "<leader>gm", "<cmd>GitMessenger<CR>", set_opts())

-- toggleterm
keymap(
	"n",
	"<leader>at",
	"<cmd>ToggleTerm direction=float<CR>",
	set_opts({
		desc = "Terminal float",
	})
)

-- test de format (sólo LSP)
keymap("n", "<leader>FT", function()
	vim.lsp.buf.format()
end, set_opts({ desc = "Format test" }))

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

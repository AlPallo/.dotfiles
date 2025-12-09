vim.g.mapleader = " "
local function paste()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = paste,
		["*"] = paste,
	},
}
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "/", "/\\v", { noremap = true })
vim.keymap.set("n", "?", "?\\v", { noremap = true })
vim.keymap.set(
	"v",
	"f",
	"y:let @/='\\V'.escape(@0, '\\')<CR>n",
	{ noremap = true, silent = true, desc = "Find selected text" }
)
vim.keymap.set(
	"n",
	"<leader>/",
	":let @/='\\V'.escape(@\", '\\')<CR>n",
	{ noremap = true, silent = true, desc = "Search for last yanked text" }
)
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "n", ":set hlsearch<CR>n", { noremap = true, silent = true })
vim.keymap.set("n", "N", ":set hlsearch<CR>N", { noremap = true, silent = true })
local leaderkey = "<leader>"
local l = function(after)
	return string.format("%s%s", leaderkey, after)
end
-- keeps jumps centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", l("J"), "mzJ`z")
vim.keymap.set("n", "G", "Gzz")

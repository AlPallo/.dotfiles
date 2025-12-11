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
		--["+"] = paste,
		--["*"] = paste,
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
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

vim.keymap.set("x", "Y", function()
	vim.cmd("normal! $y")
end, { silent = true })
vim.keymap.set("x", "D", function()
	vim.cmd("normal! $d")
end, { silent = true })

vim.keymap.set("n", "<leader>pe", function()
	local content = vim.fn.getreg("+")
	if not content or content == "" then
		print("Clipboard is empty")
		return
	end
	local clipboard_lines = vim.split(content, "\n")
	if clipboard_lines[#clipboard_lines] == "" then
		table.remove(clipboard_lines)
	end
	local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local line_count = vim.api.nvim_buf_line_count(0)
	for i, clip_line in ipairs(clipboard_lines) do
		local target_row = r + i - 2
		if target_row < line_count then
			local current_line_content = vim.api.nvim_buf_get_lines(0, target_row, target_row + 1, false)[1]
			local new_content = current_line_content .. clip_line
			vim.api.nvim_buf_set_lines(0, target_row, target_row + 1, false, { new_content })
		end
	end
end, { desc = "[p]aste to [e]nd of each line" })

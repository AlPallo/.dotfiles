vim.g.mapleader = " "

local function paste()
	return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
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

vim.keymap.set("x", "Y", function()
	vim.cmd("normal! $y")
end, { silent = true })
vim.keymap.set("x", "D", function()
	vim.cmd("normal! $d")
end, { silent = true })

vim.keymap.set("n", "<leader>pe", function()
	local count = vim.v.count == 0 and 1 or vim.v.count
	local content = vim.fn.getreg("+")
	local content_lines = {}
	if type(content) == "table" and content[1] ~= nil then
		content_lines = type(content[1]) == "table" and content[1] or content
	elseif type(content) == "string" and content ~= "" then
		content_lines = vim.split(content, "\n")
	end
	if #content_lines == 0 then
		print("Clipboard is empty or could not be read.")
		return
	end
	if content_lines[#content_lines] == "" then
		table.remove(content_lines)
	end

	local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local line_count = vim.api.nvim_buf_line_count(0)
	local lines_to_process = {}
	if #content_lines == 1 then
		for i = 1, count do
			table.insert(lines_to_process, {
				buffer_row = r + i - 2,
				clip_text = content_lines[1],
			})
		end
	else
		for i, clip_line in ipairs(content_lines) do
			table.insert(lines_to_process, {
				buffer_row = r + i - 2,
				clip_text = clip_line,
			})
		end
	end

	for _, item in ipairs(lines_to_process) do
		local target_row = item.buffer_row
		local clip_text = item.clip_text

		if target_row >= 0 and target_row < line_count then
			local current_line_content = vim.api.nvim_buf_get_lines(0, target_row, target_row + 1, false)[1]
			local new_content = current_line_content .. clip_text
			vim.api.nvim_buf_set_lines(0, target_row, target_row + 1, false, { new_content })
		else
			break
		end
	end
end, { desc = "[p]aste to [e]nd of each line" })

vim.keymap.set("n", "<leader>pb", function()
	local count = vim.v.count == 0 and 1 or vim.v.count
	local content = vim.fn.getreg("+")
	local content_lines = {}
	if type(content) == "table" and content[1] ~= nil then
		content_lines = type(content[1]) == "table" and content[1] or content
	elseif type(content) == "string" and content ~= "" then
		content_lines = vim.split(content, "\n")
	end
	if #content_lines == 0 then
		print("Clipboard is empty or could not be read.")
		return
	end
	if content_lines[#content_lines] == "" then
		table.remove(content_lines)
	end
	local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local line_count = vim.api.nvim_buf_line_count(0)
	local lines_to_process = {}

	if #content_lines == 1 then
		for i = 1, count do
			table.insert(lines_to_process, {
				buffer_row = r + i - 2,
				clip_text = content_lines[1],
			})
		end
	else
		for i, clip_line in ipairs(content_lines) do
			table.insert(lines_to_process, {
				buffer_row = r + i - 2,
				clip_text = clip_line,
			})
		end
	end

	for _, item in ipairs(lines_to_process) do
		local target_row = item.buffer_row
		local clip_text = item.clip_text

		if target_row >= 0 and target_row < line_count then
			local current_line = vim.api.nvim_buf_get_lines(0, target_row, target_row + 1, false)[1]

			local indent, rest = current_line:match("^(%s*)(.*)")
			local new_content = indent .. clip_text .. rest
			vim.api.nvim_buf_set_lines(0, target_row, target_row + 1, false, { new_content })
		else
			break
		end
	end
end, { desc = "[p]aste to [b]eginning of each line" })

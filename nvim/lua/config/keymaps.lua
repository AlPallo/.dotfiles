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
local opts = { noremap = true, silent = true }
vim.keymap.set("v", "<C-c>", '"+y', opts)
vim.keymap.set("n", "c", '"_c', opts)
vim.keymap.set("n", "r", '"_r', opts)
vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("n", "s", '"_s', opts)
vim.keymap.set("n", "C", '"_C', opts)
vim.keymap.set("n", "X", '"_X', opts)
vim.keymap.set("v", "c", '"_c', opts)
vim.keymap.set("v", "r", '"_r', opts)
vim.keymap.set("v", "s", '"_s', opts)
vim.keymap.set("v", "x", '"_x', opts)
vim.keymap.set("v", "X", '"_X', opts)
vim.keymap.set("n", "/", "/\\v", { noremap = true })
vim.keymap.set("n", "?", "?\\v", { noremap = true })
vim.keymap.set(
	"v",
	"<leader>f",
	"y:let @/='\\V'.escape(@0, '\\')<CR>n",
	{ noremap = true, silent = true, desc = "Find selected text" }
)
vim.keymap.set(
	"n",
	"<leader>/",
	":let @/='\\V'.escape(@\", '\\')<CR>n",
	{ noremap = true, silent = true, desc = "Search for last yanked text" }
)
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", opts)
vim.keymap.set("n", "n", ":set hlsearch<CR>n", opts)
vim.keymap.set("n", "N", ":set hlsearch<CR>N", opts)
local leaderkey = "<leader>"
local l = function(after)
	return string.format("%s%s", leaderkey, after)
end

-- keeps jumps centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", l("J"), "mzJ`z")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "<C-o>", "<C-o>zz", opts)
vim.keymap.set("n", "<C-i>", "<C-i>zz", opts)

local function half_page_down()
	local win = vim.api.nvim_get_current_win()
	local h = vim.api.nvim_win_get_height(win)
	local n = math.floor((h - 1) / 2)
	vim.cmd("normal! " .. n .. "j")
	vim.cmd("normal! zz")
end

local function half_page_up()
	local win = vim.api.nvim_get_current_win()
	local h = vim.api.nvim_win_get_height(win)
	local n = math.floor((h - 1) / 2)
	vim.cmd("normal! " .. n .. "k")
	vim.cmd("normal! zz")
end

vim.keymap.set("n", "<C-d>", half_page_down, { silent = true })
vim.keymap.set("n", "<C-u>", half_page_up, { silent = true })

vim.keymap.set("x", "Y", function()
	vim.cmd("normal! $y")
end, { silent = true })
vim.keymap.set("x", "D", function()
	vim.cmd("normal! $d")
end, { silent = true })

-- Jump visual lines instead of logical lines
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)
vim.keymap.set("n", "gj", "j", opts)
vim.keymap.set("n", "gk", "k", opts)

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

vim.api.nvim_create_user_command("W", "write", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "quit", {})

vim.keymap.set("x", "<leader>m", function()
	local mode = vim.fn.mode()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
	vim.ui.input({ prompt = "Command (each line): " }, function(input)
		if not input or input == "" then
			return
		end
		local start_line = vim.fn.line("'<")
		local end_line = vim.fn.line("'>")
		local start_col = vim.fn.col("'<")
		for i = start_line, end_line do
			if mode == "V" then
				vim.api.nvim_win_set_cursor(0, { i, 0 })
			elseif mode == "\22" then
				pcall(vim.api.nvim_win_set_cursor, 0, { i, start_col - 1 })
			end
			local success, err = pcall(vim.cmd, "normal! " .. input)
			if not success then
				print("Error on line " .. i .. ": " .. err)
			end
		end
	end)
end, { desc = "Execute command on each line of selection" })

local function subword_motion(op, char)
	local original_iskeyword = vim.bo.iskeyword
	vim.opt_local.iskeyword:remove(char)
	if op == "c" then
		vim.cmd('normal! viw"_d')
		vim.cmd("startinsert")

		vim.api.nvim_create_autocmd("InsertLeave", {
			buffer = 0,
			once = true,
			callback = function()
				vim.bo.iskeyword = original_iskeyword
			end,
		})
	elseif op == "d" then
		vim.cmd('normal! viw"_d')
		vim.bo.iskeyword = original_iskeyword
	else
		vim.cmd("normal!" .. op .. "iw")
		vim.bo.iskeyword = original_iskeyword
	end
end

local subword_delimiters = { "_", "-" }

for _, delimiter in ipairs(subword_delimiters) do
	vim.keymap.set("n", "ci" .. delimiter, function()
		subword_motion("c", delimiter)
	end)
	vim.keymap.set("n", "di" .. delimiter, function()
		subword_motion("d", delimiter)
	end)
	vim.keymap.set("n", "yi" .. delimiter, function()
		subword_motion("y", delimiter)
	end)
	vim.keymap.set("n", "vi" .. delimiter, function()
		subword_motion("v", delimiter)
	end)
end

local function clear_undo()
	local old_undolevels = vim.bo.undolevels
	vim.bo.undolevels = -1
	vim.cmd('exe "normal a \\<BS>\\<Esc>"')
	vim.bo.undolevels = old_undolevels
	print("Undo history cleared for current buffer.")
end

vim.api.nvim_create_user_command("ClearUndo", clear_undo, {})
vim.keymap.set("n", "<leader>uc", clear_undo, { desc = "Clear Undo History" })
vim.keymap.set("n", "<leader>cu", clear_undo, { desc = "Clear Undo History" })

vim.keymap.set("n", "<leader>ha", function()
	vim.lsp.buf.code_action({
		apply = true,
		filter = function(action)
			if action.command == "HarperAddToUserDict" then
				return true
			end
			return false
		end,
	})
end, { desc = "Harper: Add word to Dict" })

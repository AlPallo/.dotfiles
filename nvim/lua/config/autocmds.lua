vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = event.buf })
		vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = event.buf })
		map("<leader>K", vim.diagnostic.open_float, "Diagnostics")
		map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = ".env",
	group = group,
	callback = function(args)
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive", "fugitiveblame" },
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
		vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive" },
	callback = function(event)
		vim.keymap.set("n", "cc", function()
			vim.cmd("Git commit | redraw!")
		end, {
			buffer = event.buf,
			silent = true,
			noremap = true,
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.cmd("normal! gg")
		vim.cmd("startinsert")
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("restore_cursor_pos", { clear = true }),
	callback = function()
		local exclude = { "gitcommit" }
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local line_count = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
			vim.api.nvim_feedkeys("zvzz", "n", true)
		end
	end,
	desc = "Restore cursor position after reopening file",
})

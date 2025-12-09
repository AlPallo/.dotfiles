require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "ruff_format" },
		javascript = { "prettierd", "prettier" },
		json = { "prettier" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	formatters = {
		shfmt = {
			append_args = { "-i", "2" },
		},
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

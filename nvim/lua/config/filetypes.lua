vim.filetype.add({
	extensions = {
		env = "env_file",
	},
})

vim.api.nvim_create_autocmd("BufRead", {
	pattern = { "*.jinja", "*.j2" },
	callback = function(args)
		vim.bo[args.buf].filetype = "jinja"
	end,
})

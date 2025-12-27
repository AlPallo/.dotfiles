local rooter_augroup = vim.api.nvim_create_augroup("Rooter", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = rooter_augroup,
	callback = function()
		local root_names = { ".git" }
		local bufnr = vim.api.nvim_get_current_buf()
		local current_file = vim.api.nvim_buf_get_name(bufnr)
		local buftype = vim.bo.buftype
		local filetype = vim.bo.filetype
		if buftype ~= "" or filetype == "TelescopePrompt" or current_file == "" then
			return
		end
		local root_file = vim.fs.find(root_names, { path = current_file, upward = true })[1]
		if root_file then
			local root_dir = vim.fs.dirname(root_file)
			if root_dir ~= vim.fn.getcwd() then
				vim.cmd.cd(root_dir)
				vim.notify("Root changed to: " .. root_dir, vim.log.levels.INFO)
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	group = rooter_augroup,
	callback = function()
		vim.schedule(function()
			if vim.g["Telescope#rooter#newroot"] == nil and vim.g["Telescope#rooter#oldpwd"] ~= nil then
				vim.api.nvim_set_current_dir(vim.g["Telescope#rooter#oldpwd"])
				vim.g["Telescope#rooter#oldpwd"] = nil
			else
				vim.g["Telescope#rooter#oldpwd"] = nil
				vim.g["Telescope#rooter#newroot"] = nil
			end
		end)
	end,
})

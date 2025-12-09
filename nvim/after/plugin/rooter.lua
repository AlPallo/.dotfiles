local config = { patterns = { ".git" } }

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		if vim.g["Telescope#rooter#enabled"] ~= true then
			return
		end
		vim.schedule(function()
			if vim.bo.filetype == "TelescopePrompt" then
				if vim.g["Telescope#rooter#oldpwd"] == nil then
					vim.g["Telescope#rooter#oldpwd"] = vim.uv.cwd()
				end
				local rootdir = vim.fs.dirname(vim.fs.find(config.patterns, { upward = true })[1])
				if rootdir ~= nil then
					vim.g["Telescope#rooter#newroot"] = rootdir
					vim.api.nvim_set_current_dir(rootdir)
				end
			end
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	callback = function()
		if vim.g["Telescope#rooter#enabled"] ~= true then
			return
		end
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

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

local function has_ansible_cfg(path)
	local dir = vim.fs.dirname(path)
	return vim.fs.find("ansible.cfg", {
		path = dir,
		upward = true,
		stop = vim.env.HOME,
	})[1] ~= nil
end

vim.filetype.add({
	extension = {
		yml = function(path, _)
			if has_ansible_cfg(path) then
				return "yaml.ansible"
			end
			return "yaml"
		end,
		yaml = function(path, _)
			if has_ansible_cfg(path) then
				return "yaml.ansible"
			end
			return "yaml"
		end,
	},
})

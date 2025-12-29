local builtin = require("telescope.builtin")
require("telescope").setup({
	extensions = {
		rooter = {
			enable = true,
			patterns = { ".git" },
		},
	},
	defaults = {
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				height = 0.95, -- occupy most of the screen vertically
				width = 0.8, -- keep some margins on the sides
				preview_cutoff = 1, -- always show preview (never hide due to width)
				preview_height = 0.5, -- preview takes up half of the window height
			},
		},
		mappings = {
			i = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
			},
			n = {
				["j"] = require("telescope.actions").move_selection_next,
				["k"] = require("telescope.actions").move_selection_previous,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = {
				"fdfind",
				"--exclude",
				".git",
				"--exclude",
				".un~",
				"--exclude",
				"venv",
				"--exclude",
				"node_modules",
				"--type",
				"f",
				"--type",
				"d",
			},
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files and directories" })
vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Telescope find git files" })
vim.keymap.set("n", "<leader>df", function()
	builtin.find_files({
		prompt_title = "Dotfiles",
		cwd = "~/.dotfiles",
	})
end, { desc = "Telescope find dotfiles" })
vim.keymap.set("n", "<leader>of", builtin.oldfiles, { desc = "Telescope previous buffers" })
vim.keymap.set("n", "<leader>ps", function()
	local input = vim.fn.input("Grep > ")
	if input ~= "" then
		require("fzf-lua").grep({ search = input })
	end
end)

vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function()
		vim.wo.wrap = true
		if vim.bo.filetype ~= "help" then
			vim.wo.number = true
		end
	end,
})

vim.keymap.set("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopePromptCounter", { bg = "#171717" })
vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = "#4c566a" })

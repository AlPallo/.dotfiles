-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "master",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = {
			{
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
	},
	{
		"benomahony/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"hrsh7th/nvim-cmp",
		},
		run = "cargo build --release",
		build = "cargo build --release",
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	"echasnovski/mini.nvim",
	"stevearc/oil.nvim",
	"lewis6991/gitsigns.nvim",
	"stevearc/conform.nvim",
	"nvim-tree/nvim-web-devicons",
	"tpope/vim-fugitive",
	"alexghergh/nvim-tmux-navigation",
	{ "rmehri01/onenord.nvim", priority = 100, opts = {} },
	"mbbill/undotree",
	"neovim/nvim-lspconfig",
	{
		"esmuellert/vscode-diff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		config = function()
			require("vscode-diff").setup({
				keymaps = {
					view = {
						quit = "q",
						next_hunk = "n",
						prev_hunk = "N",
						next_file = "f",
						prev_file = "F",
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"jake-stewart/auto-cmdheight.nvim",
		lazy = false,
		opts = {
			max_lines = 5,
			duration = 2,
			remove_on_key = true,
			clear_always = false,
		},
	},
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-repeat" },
	{
		"andyg/leap.nvim",
		url = "https://codeberg.org/andyg/leap.nvim",
	},
})

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
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			{ "andymass/vim-matchup" },
		},
		lazy = false,
		config = function()
			local parsers = {
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"dockerfile",
				"go",
				"graphql",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"make",
				"python",
				"query",
				"rust",
				"scss",
				"sql",
				"tsx",
				"svelte",
				"typescript",
				"vim",
				"yaml",
				"toml",
				"markdown",
				"markdown_inline",
				"regex",
				"vimdoc",
				"nix",
				"fish",
				"gitcommit",
				"git_rebase",
				"git_config",
				"gitignore",
				"gitattributes",
				"diff",
			}

			local patterns = vim.tbl_extend("force", parsers, {
				"javascriptreact",
				"typescriptreact",
				"zsh",
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = patterns,
				callback = function(ev)
					local max_filesize = 500 * 1024 -- 500 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.fs.normalize(ev.file))
					if ok and stats and stats.size < max_filesize then
						vim.bo[ev.buf].syntax = "on"
						vim.wo.foldlevel = 99
						vim.wo.foldmethod = "expr"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

						vim.treesitter.start(ev.buf)
					end
				end,
			})

			vim.treesitter.language.register("bash", "zsh")
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
			"saghen/blink.lib"
		},
		run = "cargo build --release",
		build = function() require('blink.cmp').build():wait(60000) end
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
	{ "rmehri01/onenord.nvim", priority = 1000, opts = {} },
	"mbbill/undotree",
	"neovim/nvim-lspconfig",
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		config = function()
			require("codediff").setup({
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
	{ "tpope/vim-repeat" },
	{
		"andyg/leap.nvim",
		url = "https://codeberg.org/andyg/leap.nvim",
	},
	{
		"wurli/visimatch.nvim",
		opts = {},
	},
})

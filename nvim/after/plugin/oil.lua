local oil = require("oil")
local actions = require("oil.actions")

oil.setup({
	default_file_explorer = true,
	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
	delete_to_trash = false,
	-- Skip the confirmation popup for simple operations (:help
	skip_confirm_for_simple_edits = true,
	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
	-- (:help prompt_save_on_select_new_entry)
	prompt_save_on_select_new_entry = true,
	-- Set to true to watch the filesystem for changes and reload oil
	watch_for_changes = true,
	-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
	-- Additionally, if it is a string that matches "actions.<name>",
	-- it will use the mapping at require("oil.actions").<name>
	-- Set to `false` to remove a keymap
	-- See :help oil-actions for a list of all available actions
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<C-r>"] = { "actions.refresh", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},
	use_default_keymaps = false,
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = false,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			-- Always show these files
			local always_show = {
				[".env"] = true,
				[".gitignore"] = true,
				[".config"] = true,
				[".dotfiles"] = true,
			}

			if always_show[name] then
				return false -- NOT hidden
			end

			-- Otherwise hide files starting with a dot
			return name:match("^%.") ~= nil
		end,
		-- This function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- Sort file names with numbers in a more intuitive order for humans.
		-- Can be "fast", true, or false. "fast" will turn it off for large directories.
		natural_order = "fast",
		-- Sort file and directory names case insensitive
		case_insensitive = false,
		sort = {
			-- sort order can be "asc" or "desc"
			-- see :help oil-columns to see which columns are sortable
			{ "type", "asc" },
			{ "name", "asc" },
		},
		-- Customize the highlight group for the file name
		highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
			return nil
		end,
	},
	-- Extra arguments to pass to SCP when moving/copying files over SSH
	extra_scp_args = {},
	-- EXPERIMENTAL support for performing file operations with git
	git = {
		-- Return true to automatically git add/mv/rm files
		add = function(path)
			return false
		end,
		mv = function(src_path, dest_path)
			return true
		end,
		rm = function(path)
			return true
		end,
	},
	-- Configuration for the floating window in oil.open_float
	float = {
		-- Padding around the floating window
		padding = 2,
		-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		max_width = 0,
		max_height = 0,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
		get_win_title = nil,
		-- preview_split: Split direction: "auto", "left", "right", "above", "below".
		preview_split = "auto",
		-- This is the config that will be passed to nvim_open_win.
		-- Change values here to customize the layout
		override = function(conf)
			return conf
		end,
	},
	-- Configuration for the file preview window
	preview_win = {
		-- Whether the preview window is automatically updated when the cursor is moved
		update_on_cursor_moved = true,
		-- How to open the preview window "load"|"scratch"|"fast_scratch"
		preview_method = "fast_scratch",
		-- A function that returns true to disable preview on a file e.g. to avoid lag
		disable_preview = function(filename)
			return false
		end,
		-- Window-local options to use for preview window buffers
		win_options = {},
	},
	-- Configuration for the floating action confirmation window
	confirmation = {
		-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_width and max_width can be a single value or a list of mixed integer/float types.
		-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
		max_width = 0.9,
		-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
		min_width = { 40, 0.4 },
		-- optionally define an integer/float for the exact width of the preview window
		width = nil,
		-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
		-- min_height and max_height can be a single value or a list of mixed integer/float types.
		-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
		max_height = 0.9,
		-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
		min_height = { 5, 0.1 },
		-- optionally define an integer/float for the exact height of the preview window
		height = nil,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
	},
	-- Configuration for the floating progress window
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = "rounded",
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	-- Configuration for the floating SSH window
	ssh = {
		border = "rounded",
	},
	-- Configuration for the floating keymaps help window
	keymaps_help = {
		border = "rounded",
	},
})

local function cd_to_project_root()
	local root_names = { ".git" }
	local current_file_path = vim.api.nvim_buf_get_name(0)
	if current_file_path == "" then
		return
	end
	local start_dir = vim.fs.dirname(current_file_path)
	local root_file = vim.fs.find(root_names, { path = start_dir, upward = true, limit = 1 })[1]
	if root_file then
		local root = vim.fs.dirname(root_file)
		vim.fn.chdir(root)
	end
end

vim.keymap.set("n", "<leader>pv", function()
	oil.open()
	vim.schedule(function()
		actions.cd.callback()
		print("")
	end)
end, { desc = "Open Oil (auto select + cd)" })

vim.keymap.set("n", "<CR>", function()
	if vim.bo.filetype == "oil" then
		actions.select.callback()
		vim.defer_fn(function()
			if vim.bo.filetype == "oil" then
				actions.cd.callback()
				print("")
			else
				cd_to_project_root()
			end
		end, 50)
	end
end, { desc = "Open directory or file in Oil" })

local oil_clipboard_group = vim.api.nvim_create_augroup("OilClipboard", { clear = true })

-- 1. Disable clipboard when entering Oil (isolates Oil actions)
vim.api.nvim_create_autocmd("BufEnter", {
	group = oil_clipboard_group,
	callback = function()
		if vim.bo.filetype == "oil" then
			vim.opt.clipboard = ""
			vim.defer_fn(function()
				if vim.bo.filetype == "oil" then
					actions.cd.callback()
					print("")
				end
			end, 50)
		end
	end,
})

-- 2. Restore clipboard when leaving Oil (restores OSC52 for your code)
vim.api.nvim_create_autocmd("BufLeave", {
	group = oil_clipboard_group,
	callback = function()
		if vim.bo.filetype == "oil" then
			vim.opt.clipboard = "unnamedplus"
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "oil://*",
	group = vim.api.nvim_create_augroup("OilLspRefresh", { clear = true }),
	callback = function()
		vim.defer_fn(function()
			local clients = vim.lsp.get_clients()
			if #clients > 0 then
				vim.cmd("LspRestart")
			end
		end, 100)
	end,
})

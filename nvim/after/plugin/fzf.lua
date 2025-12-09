require("fzf-lua").setup({
	fzf_colors = {
		["fg"] = { "fg", { "Comment" } },
		["hl"] = { "fg", { "Normal" } },
		["fg+"] = { "fg", { "PmenuSel" } },
		["bg+"] = { "bg", { "PmenuSel" } },
		["gutter"] = "-1",
		["hl+"] = { "fg", { "PmenuSel" }, "italic", "underline" },
		["query"] = { "fg", { "Cursor" } },
		["info"] = { "fg", { "Comment" } },
		["border"] = { "fg", { "Normal" } },
		["separator"] = { "fg", { "Comment" } },
		["prompt"] = { "fg", { "Normal" } },
		["pointer"] = { "fg", { "PmenuSel" } },
		["marker"] = { "fg", { "Pmenu" } },
		["header"] = { "fg", { "Normal" } },
	},
})
vim.api.nvim_set_hl(0, "FzfLuaNormal", { bg = "#171717" })
vim.api.nvim_set_hl(0, "FzfLuaBorder", { bg = "#171717", fg = "#808080" })
vim.api.nvim_set_hl(0, "FzfLuaTitle", { bg = "#171717", fg = "#808080" })
vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { bg = "#171717" })
vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { bg = "#171717", fg = "#808080" })
vim.api.nvim_set_hl(0, "FzfLuaPreviewTitle", { bg = "#171717", fg = "#808080" })
vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { bg = "#3c3c3c" })
vim.api.nvim_set_hl(0, "FzfLuaSearch", { bg = "#4c566a" })
vim.api.nvim_set_hl(0, "FzfLuaPrompt", { bg = "#171717" })
vim.api.nvim_set_hl(0, "FzfLuaPromptPrefix", { bg = "#171717" })
vim.api.nvim_set_hl(0, "FzfLuaPromptNormal", { bg = "#171717" })
vim.api.nvim_set_hl(0, "FzfLuaPromptBorder", { bg = "#171717", fg = "#808080" })
vim.api.nvim_set_hl(0, "FzfLuaPromptTitle", { bg = "#171717", fg = "#808080" })

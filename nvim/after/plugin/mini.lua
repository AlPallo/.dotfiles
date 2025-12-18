require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup({})
require("mini.cmdline").setup({
	autocomplete = { enable = false },
	autocorrect = { enable = false },
})
local statusline = require("mini.statusline")
statusline.setup({ use_icons = true })

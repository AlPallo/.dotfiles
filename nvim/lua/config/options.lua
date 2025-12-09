local options = {
	laststatus = 2,
	statusline = "%<%F %h%m%r%=%-14.(%l,%c%V%) %P",
	number = true,
	relativenumber = true,
	incsearch = true,
	hlsearch = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	autoindent = true,
	clipboard = "unnamedplus",
	ignorecase = true,
	smartcase = true,
	winborder = "rounded",
	termguicolors = true,
}

vim.opt.shortmess:remove("S")

for key, value in pairs(options) do
	vim.opt[key] = value
end

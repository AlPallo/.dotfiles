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
	scrolloff = 5,
	swapfile = false,
	undofile = true,
	undodir = vim.fn.expand("~/.nvim/undodir"),
	cmdheight = 0,
}

vim.opt.shortmess:remove("S")
vim.opt.shortmess:append("c")

for key, value in pairs(options) do
	vim.opt[key] = value
end

if not vim.fn.isdirectory(vim.opt.undodir:get()[1]) then
	vim.fn.mkdir(vim.opt.undodir:get()[1], "p", 0700)
end

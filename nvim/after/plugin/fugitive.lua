local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>gs", "<cmd>vertical Git<cr>", opts)
vim.keymap.set("n", "<leader>gb", "<cmd>vertical G blame<cr>", opts)

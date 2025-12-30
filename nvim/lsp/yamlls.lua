return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.ansible" },
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
		-- formatting disabled by default in yaml-language-server; enable it
		yaml = { format = { enable = true } },
	},
	on_init = function(client)
		--- https://github.com/neovim/nvim-lspconfig/pull/4016
		--- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
		--- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
		--- autocmd's which check this capability
		client.server_capabilities.documentFormattingProvider = true
	end,
}

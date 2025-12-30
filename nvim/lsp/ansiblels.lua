return {
	cmd = { "ansible-language-server", "--stdio" },
	settings = {
		ansible = {
			python = {
				interpreterPath = "python",
			},
			ansible = {
				path = "ansible",
			},
			executionEnvironment = {
				enabled = false,
			},
			validation = {
				enabled = true,
				lint = {
					enabled = true,
					path = "ansible-lint",
				},
			},
		},
	},
	filetypes = { "yaml", "yaml.ansible" },
	root_markers = { "ansible.cfg", ".ansible-lint" },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
}

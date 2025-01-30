local lspconfig = require("lspconfig")

-- Configure Pyright
lspconfig.pyright.setup{
	settings = {
		pyright = {
			disableDiagnostics = true
		},
		diagnostics = {
			severity = {
				hint = "ignore",
				information = "ignore",
				warning = "ignore",
				error = "ignore",
			},
		},
	}
}

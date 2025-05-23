return {
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = { "LspAttach" },
		config = function()
			-- Turn on LSP, formatting, and linting status and progress information
			require("fidget").setup({
				text = {
					spinner = "dots_negative",
				},
			})
		end,
	},
}

return {
	{
		"github/copilot.vim",
		lazy = false,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		opts = {
			-- provider = "copilot",
			provider = "openai",
			providers = {
				openai = {
					endpoint = "https://api.openai.com/v1",
					model = "gpt-4o-mini",
				},
			},
			windows = {
				width = 40,
				ask = {
					start_insert = false,
				},
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-telescope/telescope.nvim",
			"github/copilot.vim",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}

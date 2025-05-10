return {
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufEnter",
		config = function()
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
				},
				scope = { enabled = false },
				exclude = {
					filetypes = {
						"help",
						"lazy",
						"mason",
						"notify",
						"oil",
					},
				},
			})
		end,
	},
}

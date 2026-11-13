return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		keys = {
			"<leader>ho",
			"<leader>ha",
			"<leader>hr",
			"<leader>hc",
			"<leader>1",
			"<leader>2",
			"<leader>3",
			"<leader>4",
			"<leader>5",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("harpoon").setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
				default = {
					display = function(item)
						return vim.fn.fnamemodify(item.value, ":t")
					end,
				},
			})
		end,
	},
}

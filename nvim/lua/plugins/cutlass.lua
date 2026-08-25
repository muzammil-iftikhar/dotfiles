return {
	{
		"gbprod/cutlass.nvim",
		config = function()
			require("cutlass").setup({
				exclude = { "ndd" }, -- Exclude dd in normal mode
			})
			vim.keymap.set("n", "dd", "dd", { noremap = true, silent = true })
		end,
	},
}

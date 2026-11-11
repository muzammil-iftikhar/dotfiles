-- Detect and set the proper file type for ReasonML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "Jenkinsfile", "*.jenkinsfile", "*.Jenkinsfile" },
	desc = "Detect and set the proper file type for Jenkinsfile",
	callback = function()
		vim.cmd("setfiletype groovy")
	end,
})

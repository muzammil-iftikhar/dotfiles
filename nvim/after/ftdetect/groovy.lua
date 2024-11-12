-- Detect and set the proper file type for ReasonML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "Jenkinsfile",
	desc = "Detect and set the proper file type for Jenkinsfile",
	callback = function()
		vim.cmd("set filetype=groovy")
	end,
})

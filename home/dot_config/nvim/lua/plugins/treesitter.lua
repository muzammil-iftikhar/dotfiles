return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			-- New API: setup() only accepts install_dir
			require("nvim-treesitter").setup({
				-- install_dir = vim.fn.stdpath('data') .. '/site', -- optional
			})

			-- Install parsers explicitly
			require("nvim-treesitter").install({
				"bash",
				"c",
				"css",
				"gleam",
				"graphql",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"ocaml",
				"ocaml_interface",
				"prisma",
				"vim",
				"vimdoc",
				"luadoc",
			})

			-- Enable treesitter highlighting for all filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					-- skip 'help' as before
					if args.match == "help" then
						return
					end
					pcall(vim.treesitter.start)
				end,
			})

			-- Enable treesitter-based indentation (experimental)
			vim.api.nvim_create_autocmd("FileType", {
				-- exclude languages where indent was disabled before
				pattern = "*",
				callback = function(args)
					if args.match == "ocaml" or args.match == "ocaml_interface" then
						return
					end
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	-- textobjects config belongs in its own plugin spec
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			})
		end,
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- Plugin(s) and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Install lsp autocompletions
			"hrsh7th/cmp-nvim-lsp",

			-- Progress/Status update for LSP
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

			-- Function to run when neovim connects to a Lsp client
			---@diagnostic disable-next-line: unused-local
			local on_attach = function(_client, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				map_lsp_keybinds(buffer_number)
			end

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP Specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- LSP servers to install (see list here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers )
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- LSP Servers
				bashls = {},
				cssls = {},
				html = {},
				jsonls = {},
				marksman = {},
				pyright = {},
				sqlls = {},
				yamlls = {},
				dockerls = {},
				docker_compose_language_service = {},
				ansiblels = {},
				terraformls = {},
				gopls = {},
				ruby_lsp = {},
				groovyls = {
					cmd = {
						"java",
						"-jar",
						"/home/muzammil/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
					},
				},
				eslint = {
					cmd = { "vscode-eslint-language-server", "--stdio", "--max-old-space-size=12288" },
					settings = {
						format = false,
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							telemetry = { enabled = false },
						},
					},
				},
			}

			local formatters = {
				prettierd = {},
				stylua = {},
				black = {},
				rubyfmt = {},
				shfmt = {},
			}

			local manually_installed_servers = { "ocamllsp", "gleam" }

			local mason_tools_to_install = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters))

			local ensure_installed = vim.tbl_filter(function(name)
				return not vim.tbl_contains(manually_installed_servers, name)
			end, mason_tools_to_install)

			require("mason-tool-installer").setup({
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				-- debounce_hours = 12,
				ensure_installed = ensure_installed,
			})

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					on_attach = on_attach,
					settings = config.settings,
				})
			end

			-- Setup mason so it can manage 3rd party LSP servers
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			require("mason-lspconfig").setup({
				automatic_enable = true,
			})

			-- Configure borderd for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagnostics border
			vim.diagnostic.config({
				float = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				sh = { "shfmt" },
				dockerfile = { "hadolint" },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				less = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				graphql = { "prettierd", "prettier", stop_after_first = true },
				handlebars = { "prettierd", "prettier", stop_after_first = true },
				ruby = { "rubyfmt" },
				groovy = { "npm-groovy-lint" },
			},
		},
	},
}

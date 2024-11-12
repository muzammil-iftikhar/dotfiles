local linters = require "lvim.lsp.null-ls.formatters"
linters.setup { { command = "black", filetypes = { "python" } } }

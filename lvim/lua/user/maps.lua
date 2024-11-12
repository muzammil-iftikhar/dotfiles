lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"
lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.insert_mode["jj"] = "<Esc>"
lvim.keys.insert_mode["jk"] = "<Esc>"

-- which key single key mapping
-- lvim.builtin.which_key.mappings["P"] = {
--   "<cmd>lua require'telescope'.extensions.project.project{}<CR>", "Projects"
-- }
--

-- which key menu mapping
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

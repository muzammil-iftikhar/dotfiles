local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.keymap_utils").xnoremap
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
local utils = require("user.utils")

local M = {}

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- Swap between last two buffers
nnoremap("<leader>'", "<cmd>b#<cr>", { desc = "Switch to last buffer" })

-- Save with leader key
nnoremap("<leader>w", "<cmd>w<cr>", { silent = false })

-- Save with ctrl+s
nnoremap("<C-s>", "<cmd>w<cr>", { silent = false })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = false })

-- Select all
nnoremap("<C-a>", "gg<S-v>G")

-- Split window
nnoremap("|", "<cmd>vs<cr>", { silent = false })
nnoremap("\\", "<cmd>split<cr>", { silent = false })

-- Resize panes
nnoremap("<M-.>", "<C-w><")
nnoremap("<M-,>", "<C-w>>")

-- Map Oil to <leader>e
nnoremap("<leader>e", function()
	require("oil").toggle_float()
end)

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Move between panes
nnoremap("<C-h>", "<C-w>h")
nnoremap("<C-j>", "<C-w>j")
nnoremap("<C-k>", "<C-w>k")
nnoremap("<C-l>", "<C-w>l")

-- Press 'S' for quick find/replace for the word under the cursor
--[[ nnoremap("S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end) ]]

-- Open Spectre for global find/replace
nnoremap("<leader>s", function()
	require("spectre").toggle()
end)

-- Open Spectre for global find/replace for the word under the cursor in normal mode
nnoremap("<leader>rw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })

-- Press 'U' for redo
nnoremap("U", "<C-r>")

-- Turn off highlighted results
nnoremap("<leader>no", "<cmd>noh<cr>")

-- Toggle line wrap
nnoremap("<leader>lw", "<cmd>set wrap!<cr>")

-- Move lines up and down
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- Stay in indent mode
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- Diagnostics

-- Show diagnostic description in float
vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float)

-- Toggle Diagnostics
local diagnostics_active = true
vim.keymap.set("n", "<leader>d", function()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end)

-- Lazygit
nnoremap("<leader>lg", function()
	vim.cmd("LazyGit")
end)

-- Goto next diagnostic of any severity
nnoremap("]d", function()
	-- vim.diagnostic.goto_next({})
	vim.diagnostic.jump({ count = 1, float = true })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
	-- vim.diagnostic.goto_prev({})
	vim.diagnostic.jump({ count = -1, float = true })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
	vim.diagnostic.jump({
		count = 1,
		severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
		float = true,
	})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
	vim.diagnostic.jump({
		count = -1,
		severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
		float = true,
	})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
	vim.diagnostic.jump({
		count = 1,
		severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.WARN },
		float = true,
	})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
	vim.diagnostic.jump({
		count = -1,
		severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.WARN },
		float = true,
	})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Resize split windows to be equal size
nnoremap("<leader>=", "<C-w>=")

-- Press leader f to format
nnoremap("<leader>f", ":Format<cr>")

-- Press leader ro to rotate open windows
nnoremap("<leader>ro", ":RotateWindows<cr>", { desc = "[R]otate [W]indows" })

-- Press gx to open the link under the cursor
nnoremap("gx", ":sil !open <cWORD><cr>", { silent = true })

-- Harpoon keybinds --
-- Open harpoon ui
nnoremap("<leader>ho", function()
	harpoon_ui.toggle_quick_menu()
end)

-- Add current file to harpoon
nnoremap("<leader>ha", function()
	harpoon_mark.add_file()
end)

-- Remove current file from harpoon
nnoremap("<leader>hr", function()
	harpoon_mark.rm_file()
end)

-- Remove all files from harpoon
nnoremap("<leader>hc", function()
	harpoon_mark.clear_all()
end)

-- Quickly jump to harpooned files
nnoremap("<leader>1", function()
	harpoon_ui.nav_file(1)
end)

nnoremap("<leader>2", function()
	harpoon_ui.nav_file(2)
end)

nnoremap("<leader>3", function()
	harpoon_ui.nav_file(3)
end)

nnoremap("<leader>4", function()
	harpoon_ui.nav_file(4)
end)

nnoremap("<leader>5", function()
	harpoon_ui.nav_file(5)
end)

-- Git keymaps --
nnoremap("<leader>gb", ":Gitsigns toggle_current_line_blame<cr>")
nnoremap("<leader>gf", function()
	local cmd = {
		"sort",
		"-u",
		"<(git diff --name-only --cached)",
		"<(git diff --name-only)",
		"<(git diff --name-only --diff-filter=U)",
	}

	if not utils.is_git_directory() then
		vim.notify(
			"Current project is not a git directory",
			vim.log.levels.WARN,
			{ title = "Telescope Git Files", git_command = cmd }
		)
	else
		require("telescope.builtin").git_files()
	end
end, { desc = "Search [G]it [F]iles" })

-- Telescope keybinds --
nnoremap("<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
nnoremap("<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch Open [B]uffers" })
nnoremap("<leader>sf", function()
	require("telescope.builtin").find_files({ hidden = true })
end, { desc = "[S]earch [F]iles" })
nnoremap("<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
nnoremap("<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --
M.map_lsp_keybinds = function(buffer_number)
	nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
	nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

	nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

	-- Telescope LSP keybinds --
	nnoremap(
		"gr",
		require("telescope.builtin").lsp_references,
		{ desc = "LSP: [G]oto [R]eferences", buffer = buffer_number }
	)

	nnoremap(
		"gi",
		require("telescope.builtin").lsp_implementations,
		{ desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number }
	)

	-- See `:help K` for why this keymap
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, { desc = "LSP: Hover Documentation", buffer = buffer_number })
	vim.keymap.set("n", "<leader>k", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, { desc = "LSP: Hover Documentation", buffer = buffer_number })
	vim.keymap.set("i", "<C-k>", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, { desc = "LSP: Hover Documentation", buffer = buffer_number })
end

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

-- Insert --
-- Map jj to <esc>
inoremap("jj", "<esc>")

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vnoremap("<space>", "<nop>")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vnoremap("L", "$<left>")
vnoremap("H", "^")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
nnoremap("L", "$")
nnoremap("H", "^")

-- Paste without losing the contents of the register
vnoremap("<C-M-j>", ":m '>+1<CR>gv=gv")
vnoremap("<C-M-k>", ":m '<-2<CR>gv=gv")

-- Terminal --
-- Enter normal mode while in a terminal
tnoremap("<esc>", [[<C-\><C-n>]])
tnoremap("jj", [[<C-\><C-n>]])

-- Window navigation from terminal
tnoremap("<C-h>", [[<Cmd>wincmd h<CR>]])
tnoremap("<C-j>", [[<Cmd>wincmd j<CR>]])
tnoremap("<C-k>", [[<Cmd>wincmd k<CR>]])
tnoremap("<C-l>", [[<Cmd>wincmd l<CR>]])

-- Reenable default <space> functionality to prevent input delay
tnoremap("<space>", "<space>")

return M

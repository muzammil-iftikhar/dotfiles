return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			-- "catppuccin/nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local harpoon = require("harpoon")

			local function truncate_branch_name(branch)
				if not branch or branch == "" then
					return ""
				end

				-- Match the branch name to the specified format
				local _, _, ticket_number = string.find(branch, "skdillon/sko%-(%d+)%-")

				-- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
				if ticket_number then
					return "sko-" .. ticket_number
				else
					return branch
				end
			end

			local function harpoon_component()
				local total_marks = #harpoon:list().items

				if total_marks == 0 then
					return ""
				end

				local current_mark = "—"

				local function get_current_index()
					local current_path = vim.api.nvim_buf_get_name(0)
					local buffer_name = vim.loop.fs_realpath(current_path)
					for index, item in ipairs(harpoon:list().items) do
						if item.value == buffer_name then
							return index
						end
					end
					return nil -- not found
				end

				local mark_idx = get_current_index()
				if mark_idx ~= nil then
					current_mark = tostring(mark_idx)
				end

				return string.format("󱡅 %s/%d", current_mark, total_marks)
			end

			local function git_diff_custom()
				local gitsigns = vim.b.gitsigns_status_dict
				if not gitsigns then
					return ""
				end
				local added = gitsigns.added and (" " .. gitsigns.added) or ""
				local changed = gitsigns.changed and (" " .. gitsigns.changed) or ""
				local removed = gitsigns.removed and (" " .. gitsigns.removed) or ""
				return table.concat({ added, changed, removed }, " ")
			end

			local function progress_bar()
				local current_line = vim.fn.line(".")
				local total_lines = vim.fn.line("$")
				local width = 10
				local filled = math.floor((current_line / total_lines) * width)
				local empty = width - filled
				return string.rep("█", filled) .. string.rep("░", empty)
			end

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "horizon",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					-- section_separators = { left = "█", right = "█" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
				},
				sections = {
					lualine_b = {
						{ "branch", icon = "", fmt = truncate_branch_name },
						harpoon_component,
						git_diff_custom,
						"diagnostics",
					},
					lualine_c = {
						{ "filename", path = 1 },
					},
					lualine_x = {
						"lsp_status",
						"filetype",
					},
					lualine_y = {
						progress_bar,
					},
				},
			})
		end,
	},
}

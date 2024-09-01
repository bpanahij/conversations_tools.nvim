-- File: ~/.config/nvim/lua/conversation_tools/init.lua

local M = {}

function M.setup(opts)
	opts = opts or {}
	M.base_url = opts.base_url
		or "https://us-west-1.console.aws.amazon.com/cloudwatch/home?region=us-west-1#logsV2:log-groups/log-group/CarterLogGroup/log-events/{REPLACE_THIS_STRING}$3Fstart$3D1722470400000$26end$3D1722556799000"
end

function M.insert_url_with_selection()
	-- Get the visually selected text
	vim.cmd('normal! "zy')
	local selected_text = vim.fn.getreg("z")

	-- Replace the placeholder with the selected text
	local final_url = string.gsub(M.base_url, "{REPLACE_THIS_STRING}", selected_text)

	-- Get the current cursor position
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]
	local col = cursor[2]

	-- Insert a new line below the current line and put the URL there
	vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
	vim.api.nvim_buf_set_lines(0, row + 1, row + 1, false, { final_url })

	-- Move the cursor to the end of the inserted URL
	vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
end

-- Set up the command
vim.api.nvim_create_user_command("InsertUrlWithSelection", function()
	M.insert_url_with_selection()
end, { range = true })

return M

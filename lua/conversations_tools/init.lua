local M = {}

function M.setup(opts)
	opts = opts or {}
	M.base_url = opts.base_url
		or "https://us-west-1.console.aws.amazon.com/cloudwatch/home?region=us-west-1#logsV2:log-groups/log-group/CarterLogGroup/log-events/{REPLACE_THIS_STRING}$3Fstart$3D1722470400000$26end$3D1722556799000"
	print("Plugin setup complete. Base URL: " .. M.base_url)
end

function M.insert_url_with_selection()
	print("Function insert_url_with_selection called")

	-- Get the visually selected text
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	if #lines == 0 then
		print("No text selected")
		return
	end

	-- If multiple lines are selected, join them
	local selected_text = table.concat(lines, "\n")

	-- If it's a single line, but partial, extract the correct portion
	if #lines == 1 then
		local start_col = start_pos[3]
		local end_col = end_pos[3]
		selected_text = string.sub(selected_text, start_col, end_col)
	end

	print("Selected text: " .. selected_text)

	-- Replace the placeholder with the selected text
	local final_url = string.gsub(M.base_url, "{REPLACE_THIS_STRING}", selected_text)
	print("Final URL: " .. final_url)

	-- Get the current cursor position
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]

	-- Insert a new line below the current line and put the URL there
	vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
	vim.api.nvim_buf_set_lines(0, row + 1, row + 1, false, { final_url })

	-- Move the cursor to the end of the inserted URL
	vim.api.nvim_win_set_cursor(0, { row + 2, 0 })

	print("URL inserted on new line below")
end

-- Set up the command
vim.api.nvim_create_user_command("InsertUrlWithSelection", function()
	M.insert_url_with_selection()
end, { range = true })

return M

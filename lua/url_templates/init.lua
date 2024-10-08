local M = {}

function M.setup(opts)
	opts = opts or {}
	M.base_url = opts.base_url or "https://www.google.com?query={REPLACE_THIS_STRING}"
end

function M.insert_url_with_selection()
	-- Get the visually selected text
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local start_row, start_col = start_pos[2], start_pos[3]
	local end_row, end_col = end_pos[2], end_pos[3]

	-- Adjust for Lua's 1-based indexing
	start_col = start_col - 1

	-- Get the selected lines
	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

	if #lines == 0 then
		print("No text selected")
		return
	end

	local selected_text
	if #lines == 1 then
		-- Single line selection
		selected_text = string.sub(lines[1], start_col + 1, end_col)
	else
		-- Multi-line selection
		lines[1] = string.sub(lines[1], start_col + 1)
		lines[#lines] = string.sub(lines[#lines], 1, end_col)
		selected_text = table.concat(lines, "\n")
	end

	-- Replace the placeholder with the selected text
	local final_url = string.gsub(M.base_url, "{REPLACE_THIS_STRING}", selected_text)

	-- Get the current cursor position
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]

	-- Insert a new line below the current line and put the URL there
	vim.api.nvim_buf_set_lines(0, row, row, false, { "" })
	vim.api.nvim_buf_set_lines(0, row, row + 1, false, { final_url })
	-- Move the cursor to the end of the inserted URL
	vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end

-- Set up the command
vim.api.nvim_create_user_command("InsertUrlWithSelection", function()
	M.insert_url_with_selection()
end, { range = true })

return M

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
	vim.cmd('normal! "zy')
	local selected_text = vim.fn.getreg("z")
	print("Selected text: " .. selected_text)

	-- Replace the placeholder with the selected text
	local final_url = string.gsub(M.base_url, "{REPLACE_THIS_STRING}", selected_text)
	print("Final URL: " .. final_url)

	-- Insert the URL at the cursor position
	vim.api.nvim_put({ final_url }, "c", true, true)
	print("URL inserted into buffer")
end

-- Set up the command
vim.api.nvim_create_user_command("InsertUrlWithSelection", function()
	M.insert_url_with_selection()
end, { range = true })

return M

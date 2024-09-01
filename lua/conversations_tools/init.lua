local M = {}

function M.setup(opts)
	opts = opts or {}
	-- You can add any configuration options here
	-- For example, allowing users to customize the base URL:
	M.base_url = opts.base_url
		or "https://us-west-1.console.aws.amazon.com/cloudwatch/home?region=us-west-1#logsV2:log-groups/log-group/CarterLogGroup/log-events/{REPLACE_THIS_STRING}$3Fstart$3D1722470400000$26end$3D1722556799000"
end

function M.open_url_with_selection()
	-- Get the visually selected text
	vim.cmd('normal! "zy')
	local selected_text = vim.fn.getreg("z")

	-- Replace the placeholder with the selected text
	local final_url = string.gsub(M.base_url, "{REPLACE_THIS_STRING}", selected_text)

	-- Open the URL (this uses xdg-open on Linux, open on macOS, and start on Windows)
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start"
	else
		print("Unsupported operating system")
		return
	end

	os.execute(open_cmd .. ' "' .. final_url .. '"')
end

-- Set up the command
vim.api.nvim_create_user_command("OpenUrlWithSelection", function()
	M.open_url_with_selection()
end, { range = true })

return M

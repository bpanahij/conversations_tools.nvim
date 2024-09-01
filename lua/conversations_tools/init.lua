-- File: ~/.config/nvim/lua/conversation_tools/init.lua

local M = {}

function M.setup(opts)
	opts = opts or {}
	M.base_url = opts.base_url
		or "https://us-west-1.console.aws.amazon.com/cloudwatch/home?region=us-west-1#logsV2:log-groups/log-group/CarterLogGroup/log-events/{REPLACE_THIS_STRING}$3Fstart$3D1722470400000$26end$3D1722556799000"
	print("Plugin setup complete. Base URL: " .. M.base_url)
end

function M.open_url_with_selection()
	print("Function open_url_with_selection called")

	-- Get the visually selected text
	vim.cmd('normal! "zy')
	local selected_text = vim.fn.getreg("z")
	print("Selected text: " .. selected_text)

	-- Replace the placeholder with the selected text
	local final_url = string.gsub(M.base_url, "{REPLACE_THIS_STRING}", selected_text)
	print("Final URL: " .. final_url)

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

	print("Using command: " .. open_cmd)

	local full_command = open_cmd .. ' "' .. final_url .. '"'
	print("Executing command: " .. full_command)

	local success, result, code = os.execute(full_command)
	print(
		"Command execution result - Success: "
			.. tostring(success)
			.. ", Result: "
			.. tostring(result)
			.. ", Exit code: "
			.. tostring(code)
	)
end

-- Set up the command
vim.api.nvim_create_user_command("OpenUrlWithSelection", function()
	M.open_url_with_selection()
end, { range = true })

return M

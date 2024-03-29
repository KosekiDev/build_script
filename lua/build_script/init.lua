local M = {
	-- prefix option add a prefix to the command defined in a package.json file.
	package_json_prefix = "npm run ",
}

local function find_file_path(file_name)
	return vim.fs.find(file_name, {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})[1]
end

local function isSettingUp()
	return M.callback ~= nil
end

local function read_config_file()
	local build_config_path = find_file_path("build_config.json")
	local package_json_path = find_file_path("package.json")

	if not build_config_path and not package_json_path then
		print(
			"No config file found. You must have a file named package.json or build_config.json at the root of your project."
		)
		return nil
	end

	local commands_text = {}
	local file_json = io.open((build_config_path and build_config_path or package_json_path), "r"):read("*a")
	local json = vim.json.decode(file_json)

	if build_config_path then
		for i, x in pairs(json["scripts"]) do
			table.insert(commands_text, { i, x })
		end
	else
		for i, _ in pairs(json["scripts"]) do
			table.insert(commands_text, { M.package_json_prefix .. i, M.package_json_prefix .. i })
		end
	end

	return commands_text
end

function M.setup(options)
	-- executor_callback define a callback function that take the choosen command to execute.
	-- Then, user can do what he want with this command. Execute it with toggleterm, open new
	-- tmux session etc...
	M.callback = options.executor_callback

	-- prefix option add a prefix to the command defined in a package.json file.
	if options.package_json_prefix then
		M.package_json_prefix = options.package_json_prefix
	end
end

function M.open_quicklist(executor_callback_override)
	if not isSettingUp() and executor_callback_override == nil then
		print(
			"You must define the executor_callback function in the setup of build_script plugin or give callback to open_quicklist function to use it"
		)
		return nil
	end

	local commands = read_config_file()

	if not commands then
		return nil
	end

	if #commands == 1 then
		if executor_callback_override ~= nil then
			executor_callback_override(commands[1][2])
		else
			M.callback(commands[1][2])
		end

		return nil
	end

	vim.ui.select(commands, {
		prompt = "Choose command to run",
		format_item = function(item)
			return item[1]
		end,
	}, function(choice)
		if not choice then
			return nil
		end

		if executor_callback_override ~= nil then
			executor_callback_override(choice[2])
		else
			M.callback(choice[2])
		end
	end)
end

return M

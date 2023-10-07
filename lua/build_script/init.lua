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
		for _, x in pairs(json["scripts"]) do
			table.insert(commands_text, x)
		end
	else
		for i, _ in pairs(json["scripts"]) do
			table.insert(commands_text, M.package_json_prefix .. i)
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
	if not isSettingUp() then
		print("You must define the executor_callback function in the setup of build_script plugin to use it")
		return nil
	end

	local commands = read_config_file()

	if not commands then
		return nil
	end

	if #commands == 1 then
		M.callback(commands[1])

		return nil
	end

	vim.ui.select(commands, {
		prompt = "Choose command to run",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if not choice then
			return nil
		end

		if executor_callback_override == nil then
			M.callback(choice)
		else
			executor_callback_override(choice)
		end
	end)
end

return M

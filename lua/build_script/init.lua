local M = {}

local function find_file_path(file_name)
	return vim.fs.find(file_name, {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})[1]
end

local function read_config_file()
	local build_config_path = find_file_path("build_config.json")
	local package_json_path = find_file_path("package.json")

	if not build_config_path and not package_json_path then
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
			table.insert(commands_text, "npm run " .. i)
		end
	end

	return commands_text
end

function M.open_quicklist()
	local commands = read_config_file()

	if not commands then
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

		require("toggleterm").exec(choice, 1, 12)
		vim.o.expandtab = false
	end)
end

return M

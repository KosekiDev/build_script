# BuildScript Plugin

A plugin to provide a quicklist to execute build script defined in package.json or in a build_config.json file.

![image](https://github.com/KosekiDev/build_script/assets/62622114/fcdc5015-428f-49f4-865a-6f607d7d0dbf)

## Installation

Use your favorite Neovim plugin manager to add BuildScript Plugin.
With [lazy.vim](https://github.com/folke/lazy.nvim) :

```lua
{
    "KosekiDev/build_script",
    opts = {
        executor_callback = function(command)
	    require("toggleterm").exec(command, 1, 12)
        end,
        package_json_prefix = "npm run " -- optionnal
    }
}
```

## Usage

You must define the default executor_callback in the setup function.
This callback will be executed when you choosed a command to execute.
This callback must have a parameter that get the choosen command.

Ex with toggleterm plugin :

```lua
{
    "KosekiDev/build_script",
    opts = {
        executor_callback = function(command)
            require("toggleterm").exec(command, 1, 12)
        end,
        package_json_prefix = "npm run " -- optionnal
    }
}
```

You need a file called build_config.json at the root of your project or a package.json.
In build_config.json file, you can list script commands like in a package.json file :

```json
{
  "scripts": {
    "dev": "cargo run",
    "test": "cargo-watch -x test"
  }
}
```

Just call :OpenBuildScripts command and choose the build script that you want to execute.

Note : If only one command is defined in the configuration file, the command will run automatically.

Another example for Tmux users (create a new window with the command):

```lua
{
  "KosekiDev/build_script",
  opts = {
    executor_callback = function (command)
      local tmux_cmd = 'silent !tmux neww "' .. command .. '"'
      vim.cmd(tmux_cmd)
    end
  }
}
```

You can also call the open_quicklist function with the callback to run.

# Example :

Run the choosen command in a new tmux pane with <leader>pbs.
Run the choosen command in a new tmux windon with <leader>bs.

```lua
return {
    "KosekiDev/build_script",
    keys = {
        { "<leader>bs", "<cmd>silent :OpenBuildScripts<CR>", { desc = "Open project's build script quicklist" } },
		{
			"<leader>pbs",
			function()
				require("build_script").open_quicklist(function(command)
					local tmux_cmd = 'silent !tmux split-window "' .. command .. '"'
					vim.cmd(tmux_cmd)
				end)
			end,
			{ desc = "Open project's build script quicklist and execute the command in a tmux pane" },
		},
	},
	opts = {
		executor_callback = function(command)
			local tmux_cmd = 'silent !tmux neww "' .. command .. '; exec zsh"'
			vim.cmd(tmux_cmd)
		end,
	},
}
```

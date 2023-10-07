# BuildScript Plugin

A plugin to provide a quicklist to execute build script

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

You must define the executor_callback in the setup function.
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
    "dev": "cargo run"
  }
}
```

Just call :OpenBuildScripts command and choose the build script that you want to execute.

Note : If only one command is defined in the configuration file, the command will run automatically.

Another exemple for Tmux users (create a new window with the command):

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

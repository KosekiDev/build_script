# BuildScript Plugin

A plugin to provide a quicklist to execute build script

## Installation

Use your favorite Vim or Neovim plugin manager to add BuildScript Plugin. With [lazy.vim](https://github.com/folke/lazy.nvim), just add this line to your plugin configuration: `{"https://github.com/KosekiDev/build_script"},`.

## Usage

First, you need install [ToggleTerm](https://github.com/akinsho/toggleterm.nvim) plugin.

You need a file called build_script.json at the root of your project or a package.json.
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

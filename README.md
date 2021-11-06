# Dotfiles

This repository contains the dotfiles I personally use. It includes files for bash, vim, and tmux.

## Automatic Setup

To automatically install all dotfiles into your home directory, use the provided
`install.sh` script. 

```sh
# Clone the repo in your home directory
cd ~
git clone https://github.com/DonIsaac/.dotfiles.git

# Run the installation script
cd .dotfiles
./install.sh
```

This will create symlinks in your home directory for each dotfile. **Warning:
your existing dotfiles _will be clobbered_!** You may want to make backups of
them, e.g. `mv ~/.bashrc ~/.bashrc.backup`.

Before you run it, you must have [jq](https://stedolan.github.io/jq/)
installed. You will also probably want to have `curl` installed, but it isn't requried.

## Manual Installation

If you cannot run `install.sh` for some reason, or you want more control over
how each file is set up, you can install each file manually. To do so, create a symlink
for each file.

```sh
ln -s ~/.bashrc ~/.dotfiles/.bashrc
```

## Configuration

The `conf.json` file controls what files are linked and where. It looks like this:

```json
{
	"link": {
		"~/.bashrc": ".bashrc",
		"~/.profile": ".profile",
		"~/.bash_aliases": ".bash_aliases",
		"~/.bash_logout": ".bash_logout",
		"~/.tmux.conf": ".tmux.conf",
		"~/.tmux.conf.local": ".tmux.conf.local",
		"~/.vimrc": ".vimrc"
	},

	"shell": {
		"before": [],
		"after": []
	}
}
```

The links object tells the installation script where to find each dotfile and
where to symlink it to. Each key is where the symlink will be placed, while each
value is the name of the file to symlink to.

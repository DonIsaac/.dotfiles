# Dotfiles

This repository contains the dotfiles I personally use. It includes files for bash, vim, and tmux.

## Automatic Setup

To automatically install all dotfiles into your home directory, use the provided
`install.sh` script. 

```bash
# Clone the repo in your home directory
cd ~
git clone --recurse-submodules https://github.com/DonIsaac/.dotfiles.git

# Run the installation script
cd .dotfiles
./install.sh
```

This will create symlinks in your home directory for each dotfile. **Warning:
your existing dotfiles _will be clobbered_!** You may want to make backups of
them, e.g. `mv ~/.bashrc ~/.bashrc.backup`.

### Required Tooling

The install script relies on several tools to work properly. Some are required,
and others are optional. Missing required tools causes installation to fail,
while missing optional tools may cause certain automatic setup steps to be
skipped. The list of tools are: 

- jq _(required)_
- node _(optional)_
- curl _(optional)_
- vim/nvim _(not a dependency, but vim setup will not complete without one
  installed)_
- tmux _(not a dependency, but is installed with `-i`)_

This list is also available with the `--list-deps` flag.

The install script is capable of installing missing tools for you. To do this,
use the `-i` flag. Note that if `node` is missing, this will install
[nvm](https://github.com/nvm-sh/nvm#intro) first, then install the latest LTS
version of `node`.

```bash
# Show the binaries used by the install script
./install.sh --list-deps

# Run installation and setup, installing missing binaries beforehand.
./install.sh -i
```

## Manual Installation

If you cannot run `install.sh` for some reason, or you want more control over
how each file is set up, you can install each file manually. To do so, create a symlink
for each file. For example:

```sh
ln -s ~/.bashrc ~/.dotfiles/.bashrc
```

Then, install [vim-plug](https://github.com/junegunn/vim-plug).
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
To finish installing vim plugins, open vim and run `:PlugInstall`.

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

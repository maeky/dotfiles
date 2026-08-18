# Max's dotfiles

Personal macOS and Zsh configuration, originally forked from
[holman/dotfiles](https://github.com/holman/dotfiles).

## What is included

- Topic-based Zsh configuration
- Powerlevel10k prompt
- Homebrew paths and setup helpers
- `mise`, `pyenv`, and `rbenv` shell integration
- Git aliases and global configuration
- Zed CLI wrappers
- macOS defaults and update scripts
- Vim, Ruby, Docker, and Xcode helpers

## How it works

The repository lives at `~/.dotfiles`. `~/.zshrc` and other home-directory
configuration files are symlinked to files ending in `.symlink`.

The Zsh loader automatically sources topic files in this order:

1. Every `path.zsh`
2. Other `*.zsh` files
3. Powerlevel10k
4. Every `completion.zsh`

Executables in `bin/` are added to `PATH` and can be run directly.

## Requirements

The current configuration expects:

- macOS with Zsh
- [Homebrew](https://brew.sh/)
- `mise`, `powerlevel10k`, `pyenv`, and `rbenv`
- [Zed](https://zed.dev/) installed in `/Applications`

Install the main Homebrew dependencies with:

```sh
brew install mise powerlevel10k pyenv rbenv
```

Lando and Kiro integrations are optional and only activate when available.

## Installation

```sh
git clone git@github.com:maeky/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
exec zsh
```

`script/bootstrap` creates the symlinks and runs the repository's setup tools.
On macOS, these tools can apply system defaults, update Homebrew, and run
software updates. Review `script/bootstrap`, `bin/dot`, and `macos/` before
running them on a new machine.

## Local and private configuration

Machine-specific environment variables and secrets belong in `~/.localrc`,
not in this repository:

```sh
export EXAMPLE_TOKEN="..."
```

Protect the file and reload Zsh:

```sh
chmod 600 ~/.localrc
exec zsh
```

User-specific Git identity is stored in `git/gitconfig.local.symlink`, which is
ignored by Git and linked as `~/.gitconfig.local`.

## Zed commands

Open a project in Zed:

```sh
zed .
```

`zed-wait` waits until the opened file or project is closed. It is used by
`EDITOR` and `VISUAL` for commands that require a blocking editor.

## Adding configuration

- Add `topic/name.zsh` for automatically loaded shell configuration.
- Name it `topic/path.zsh` when it must load before other topic files.
- Name it `topic/completion.zsh` for completion setup.
- Add `topic/name.symlink` to create `~/.name` through `script/bootstrap`.
- Add executable utility commands to `bin/`.

## Maintenance

Reload the current shell after changing the configuration:

```sh
exec zsh
```

Inspect changes before committing:

```sh
git status
git diff
```

The `dot` command runs macOS defaults, Homebrew updates, and repository
installers. Review its actions before running it.

# Max's dotfiles

Reviewed macOS/Zsh setup for a clean Apple Silicon Mac. Originally forked from
[holman/dotfiles](https://github.com/holman/dotfiles).

## Before activation

Revoke credentials exposed on the old Mac, if not already done. Verify the GitHub
account's SSH keys, tokens and sessions. Do not restore old shell configuration,
private keys, plugin directories or shell caches wholesale.

The repository must be at `~/.dotfiles`. Preview the exact links:

```sh
/bin/bash ~/.dotfiles/script/bootstrap --dry-run
```

The default is preview only. After inspecting the preview and resolving conflicts:

```sh
/bin/bash ~/.dotfiles/script/bootstrap --apply
```

This links only `.zshrc`, `.gitconfig`, `.gitignore` and the global mise config.
Existing files are never deleted or overwritten. Conflicts stop the operation
before links are created. Resolve conflicts manually, preserving original files.
The script installs no software, changes no macOS defaults and runs no shell reload.
Open a new terminal only when ready to activate the configuration.

This uses a small explicit linker, not GNU Stow. The `.symlink` structure is not
a Stow package layout; do not run Stow directly against these topic directories.

## Software installation is separate

Use a fresh native Homebrew installation at `/opt/homebrew`, following
[Homebrew's official instructions](https://docs.brew.sh/Installation).
Review `Brewfile`, then explicitly run:

```sh
/opt/homebrew/bin/brew bundle --file="$HOME/.dotfiles/Brewfile"
```

The initial list includes Fresh, fzf, gh, mise and Powerlevel10k. Add apps individually
after deciding what is needed. No third-party taps are configured. `script/install`
only prints instructions. `bin/dot` only invokes the linker (preview by default).

## Shell startup

Zsh sources an explicit list. It does not load `.localrc`, Kiro, grc, pyenv or
rbenv integration. PATH starts with native Homebrew and macOS system paths;
only the reviewed `bin/` directory is appended. Custom tool paths must be added
deliberately. Powerlevel10k and mise are initialized only if available at their
known Homebrew locations. Keep completion security checks enabled. fzf provides Ctrl+R history search,
Ctrl+T file selection, Alt+C directory selection and fuzzy completion with ** + Tab.

Mise is the default runtime manager. Its global config enables paranoid mode.
`mise/config.toml` pins Node.js 24.21.0 and Python 3.14.8. Ruby is not configured. Review
project hooks, tasks, plugins and environment directives before `mise trust`.
Do not broadly trust project directories. Trust is not a sandbox.

## Private identity and SSH

Create `~/.gitconfig.local` from `git/gitconfig.local.symlink.example` and fill in
your name and email. The file belongs outside this repository. GitHub HTTPS uses
the freshly authenticated Homebrew gh credential helper; SSH uses the SSH agent.

`ssh/config.example` is a template and is not installed automatically. Merge it
manually into a reviewed `~/.ssh/config` after exporting only the PUBLIC part of
a new GitHub SSH key from 1Password to `~/.ssh/github.pub`. Private keys stay in
1Password. Review any existing Include, Match exec, ProxyCommand, LocalCommand,
IdentityAgent and ForwardAgent directives before use. Preserve host-key checking
and independently verify host fingerprints when prompted.

Zsh sets SSH_AUTH_SOCK to the 1Password macOS socket so ssh-add uses that agent.
SSH itself selects the agent through IdentityAgent in the SSH config template.
Do not reuse any private key exposed on the infected Mac.

Do not store passwords or tokens in the repository or export them globally at
shell startup. Supply secrets only to commands that need them. Shell history
can contain sensitive arguments; ignoring leading spaces is not a guarantee.

## Editors and legacy helpers

The active `bin/` contains `dot`, `e`, `editor` and optional Zed wrappers.
`EDITOR`, `VISUAL`, `e` and Git use `bin/editor`: Fresh when available on PATH,
otherwise macOS nano. No vi or Vim is selected. Fresh is included in the Brewfile as `fresh-editor`. `e file.txt` opens a file; `e` opens the editor
without a filename. Zed wrappers remain available only for explicit use.

Old scripts are in `legacy/` for reference and are not sourced, linked or placed
on PATH. They include external upload utilities, potentially unsafe shell
interpolation and system modification scripts. Repair individual helpers before
reintroducing them. Remaining Docker/Xcode aliases and completion reference files
are not loaded automatically.

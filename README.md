# Max's dotfiles

Reviewed macOS/Zsh setup for a clean Apple Silicon Mac. Originally forked from
[holman/dotfiles](https://github.com/holman/dotfiles).

## Safe recovery after an infostealer

Start from a clean Mac and obtain this repository from a trusted source. Review
the files before activating them; a Git repository is not automatically safe.
Restore selected documents and project source only after review. Do not copy an
old `auth.json`, private SSH keys, API tokens, browser/editor/Pi extensions,
plugin directories, shell caches or the entire old user/application profile.
Reinstall extensions individually from trusted sources and sign in afresh.

From a clean device, revoke compromised SSH keys on GitHub and every affected
server/service, revoke exposed tokens and sessions, and replace exposed API keys
(including OpenRouter). Creating a new key does not revoke the old one. Change
affected passwords and review account access. Keep replacement credentials out
of this repository. This setup does not perform or verify credential revocation.

## Installation order

1. Complete credential recovery, place the reviewed repository at `~/.dotfiles`,
   and read the configuration files and scripts listed below.
2. Install native Homebrew, review the Brewfile and DDEV tap, then run the bundle.
3. Preview bootstrap links, resolve conflicts manually, then apply the links.
4. Open a new terminal, install the mise runtimes and verify Node/Python/npm.
5. Configure Colima, Docker Buildx and DDEV; initialize mkcert separately.
6. Install Pi using the reviewed AI setup script and configure Herdr integration.
7. Install/sign in to the manual apps and configure 1Password's SSH agent.

Before running anything, read `README.md`, `Brewfile`, `script/bootstrap`,
`script/setup-dev.sh`, `script/setup-ai.sh` and `mise/config.toml`, plus the
Zsh files they activate and the Ghostty, Herdr and Zed configs they link.
The setup scripts have no dry-run mode; only bootstrap previews by default.
Review downloads, npm packages and integration code as well as shell scripts.

## Homebrew and Brewfile

Use a fresh native Homebrew installation at `/opt/homebrew`, following
[Homebrew's official instructions](https://docs.brew.sh/Installation).
Review `Brewfile`, then explicitly run:

```sh
/opt/homebrew/bin/brew bundle --file="$HOME/.dotfiles/Brewfile"
```

The current bundle contains:

- Shell/tools: `fresh-editor`, `fzf`, `gh`, `mise`, `powerlevel10k`.
- Terminal/AI helper: Ghostty and `herdr`.
- Development: `colima`, `docker`, `docker-buildx`, `ddev/ddev/ddev`, `mkcert`.
- Apps: Zed, Slack, Google Chrome, Linear, Fantastical, Ice (`jordanbaird-ice`), Spotify.

The Brewfile explicitly adds `tap "ddev/ddev"`. Review and trust this external
tap's provenance and formula before installation; it is the tap used by the
[official DDEV installation instructions](https://ddev.github.io/ddev/en/stable/users/install/ddev-installation/).
The Brewfile's opening comment saying there are no third-party taps is stale;
the actual tap entry is authoritative. This tap review is separate from
`mise trust`, which approves runtime configuration files.

`script/install` only prints installation instructions. `bin/dot` only invokes
bootstrap (preview by default). Neither runs the bundle or either setup script.
The Brewfile does not pin package/app versions.

## Bootstrap: preview, then apply

The repository must be at `~/.dotfiles`. Preview the exact links:

```sh
/bin/bash ~/.dotfiles/script/bootstrap --dry-run
```

After inspecting the preview and resolving conflicts:

```sh
/bin/bash ~/.dotfiles/script/bootstrap --apply
```

Bootstrap links only these reviewed files:

| Repository source | Destination |
| --- | --- |
| `zsh/zshrc.symlink` | `~/.zshrc` |
| `git/gitconfig.symlink` | `~/.gitconfig` |
| `git/gitignore.symlink` | `~/.gitignore` |
| `mise/config.toml` | `~/.config/mise/config.toml` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `zed/settings.json` | `~/.config/zed/settings.json` |

Existing files are never deleted or overwritten. Conflicts stop the operation
before links are created; preserve originals and resolve conflicts manually.
Already-correct links are left in place. Bootstrap installs no software, changes
no macOS defaults and runs no shell reload. Open a new terminal when ready to
activate the Zsh configuration.

This uses a small explicit linker, not GNU Stow. The `.symlink` structure is not
a Stow package layout; do not run Stow directly against these topic directories.

## Shell and mise runtimes

Zsh sources an explicit list. It does not load `.localrc`, Kiro, grc, pyenv or
rbenv integration. PATH starts with native Homebrew and macOS system paths;
only the reviewed `bin/` directory is appended before mise activation. Add custom
tool paths deliberately. Powerlevel10k and mise initialize only if available at
their known Homebrew locations. Keep completion security checks enabled.
fzf provides Ctrl+R history search, Ctrl+T file selection, Alt+C directory
selection and fuzzy completion with ** + Tab.

Mise is the default runtime manager. `mise/config.toml` enables paranoid mode
and pins Node.js `24.21.0` and Python `3.14.8`; Ruby is not configured.
After bootstrap and opening a new terminal, run outside a project directory:

```sh
cd "$HOME/.dotfiles"
mise install
mise current
node --version
python --version
npm --version
```

The linked global mise config does not require `mise trust`. Review each
project's configs, hooks, tasks, plugins and environment directives before
trusting its specific file, for example `mise trust /path/to/project/mise.toml`.
Do not broadly trust directories or use `mise trust --all` as a shortcut.
[Paranoid mode](https://mise.jdx.dev/paranoid.html) requires renewed trust when
project config content changes. Trust is not a sandbox. If a pinned runtime
cannot be installed, investigate the error before changing the version.

## Colima, Docker Buildx, DDEV and mkcert

After installing the bundle and reviewing the script:

```sh
/bin/bash ~/.dotfiles/script/setup-dev.sh
```

The script creates `~/.docker/cli-plugins` and links Homebrew's Buildx binary
there only if no file or symlink already exists at the destination. It does not
repair an existing incorrect or broken link; inspect that manually if Buildx
fails. It sets DDEV's global `docker-buildx-version` to `system`, then starts
Colima with 6 CPUs, 8 GiB memory and a 100 GiB disk if `colima status` fails.
It leaves a running Colima instance's resources unchanged. Review those resource
values for the target Mac before running. Docker CLI uses Colima as its runtime.

The script does not install the local certificate authority. Initialize it
separately for local HTTPS, as described in the
[DDEV documentation](https://ddev.github.io/ddev/en/stable/users/install/ddev-installation/):

```sh
mkcert -install
```

This adds mkcert's local CA to trust stores and may request an administrator
password. Generate it on the clean Mac; do not restore the old CA private key.
Check the environment afterwards:

```sh
colima status
docker context show
docker version
docker buildx version
ddev version
```

If Docker points at another runtime, inspect the context before starting a
project. Project configuration and `ddev start` are separate steps; review
project hooks, add-ons and container definitions before running them.

## Ghostty, Pi and Herdr

Ghostty is installed by Homebrew and its config is linked by bootstrap. The
current config sets font size 14, window padding, Option-as-Alt and clipboard
copy-on-select. Launch Ghostty and open a new shell after setup.

Verify Node/npm come from mise before installing Pi (`command -v node` and
`command -v npm`). Then, after reviewing the script and npm package:

```sh
/bin/bash ~/.dotfiles/script/setup-ai.sh
```

The script requires npm on PATH. If `pi` is absent, it runs
`npm install -g @mariozechner/pi-coding-agent`; otherwise it skips installation.
It neither pins nor upgrades Pi, and checks only that npm exists, not that mise
provides it. Do not run it with sudo. A different mise Node version may need its
own global Pi installation.

If `herdr` is available, the script runs `herdr integration install pi`.
Herdr itself comes from the Brewfile; bootstrap links its config, currently
`onboarding = false`. Integration installation is a separate action that can
modify Pi's integration files. Check `pi --version` and review the resulting
integration before use. Authenticate afresh with replacement credentials;
never restore old Pi `auth.json`, tokens or extensions.

## Manual applications and accounts

These steps are separate from the Brewfile and setup scripts:

| Source | Applications / action |
| --- | --- |
| Mac App Store | Install Mailbutler and sign in. |
| Google Chrome | Install Google Chat as a Chrome web app and sign in. |
| Setapp | Install Setapp, sign in, then install PixelSnap, CleanShot X, TablePlus and Paste. |
| Separate purchase | Download MacWhisper using the purchase email and activate its license. |
| 1Password | Install/sign in, enable its SSH agent, and configure a new SSH key as below. |

MacWhisper uses the separate purchase, rather than the Setapp version. Keep
license keys and account credentials outside Git. These app sources reflect
the reported installation choices; the scripts do not verify account access,
licenses or successful app installation.

## Private identity and 1Password SSH agent

Create `~/.gitconfig.local` from `git/gitconfig.local.symlink.example` and fill in
your name and email. The file belongs outside this repository. GitHub HTTPS uses
the freshly authenticated Homebrew gh credential helper; SSH uses the SSH agent.
Use a fresh `gh auth login` if needed.

Enable the SSH agent in 1Password's settings. `ssh/config.example` is a template
and is not installed automatically. Merge it manually into a reviewed
`~/.ssh/config` after exporting only the PUBLIC part of a new GitHub SSH key
from 1Password to `~/.ssh/github.pub` and registering that public key with GitHub.
Private keys stay in 1Password. Revoke exposed old keys on every affected service.

Review existing Include, Match exec, ProxyCommand, LocalCommand, IdentityAgent
and ForwardAgent directives before use. Preserve host-key checking and
independently verify host fingerprints when prompted. Zsh sets SSH_AUTH_SOCK
to the 1Password macOS socket so ssh-add uses that agent; SSH itself selects the
agent through IdentityAgent in the template.

Do not store passwords or tokens in the repository or export them globally at
shell startup. Supply secrets only to commands that need them. Shell history
can contain sensitive arguments; ignoring leading spaces is not a guarantee.

## Editors and legacy helpers

The active `bin/` contains `dot`, `e`, `editor` and optional Zed wrappers.
`EDITOR`, `VISUAL`, `e` and Git use `bin/editor`: Fresh when available on PATH,
otherwise macOS nano. Fresh is installed as `fresh-editor`. `e file.txt` opens
a file; `e` opens the editor without a filename.

Zed is installed by Homebrew. Bootstrap links settings that disable diagnostic
and metrics telemetry and Vim mode, set font sizes 14 and tab size 2, and enable
format-on-save. `zed` explicitly opens Zed via its CLI in `/Applications/Zed.app`;
`zed-wait` adds `--wait`. Review and install any needed extensions afresh.

Old scripts are in `legacy/` for reference and are not sourced, linked or placed
on PATH. They include external upload utilities, potentially unsafe shell
interpolation and system modification scripts. Repair individual helpers before
reintroducing them. Remaining Docker/Xcode aliases and completion reference files
are not loaded automatically.

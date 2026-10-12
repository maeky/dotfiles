export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
export LANG="en_US.UTF-8"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
# HIST_IGNORE_SPACE is a convenience, not a secret-protection mechanism.
setopt HIST_VERIFY
bindkey '^?' backward-delete-char

function c() { cd -- "$PROJECTS/${1:-}"; }

export XIDOTS_DIR="/home/xitonight/.xidots"

if [ -z $SSH_CONNECTION ]; then
  # create the session if it doesn't exist
  if ! tmux has-session -t "main" 2>/dev/null; then
    # create session and windows
    tmux new-session -d -s "main" -n "main"
    tmux neww -d -t "main:2" -n "ssh" 2>/dev/null

    # split ssh in two panes
    tmux split-window -h -t main:2

    # automatically connect to mini in both panes in "ssh" window
    tmux send-keys -t main:2.1 'tailscale ssh xitonight@mini' Enter
    tmux send-keys -t main:2.2 'tailscale ssh xitonight@mini' Enter
  fi
  # if not connected to a tmux session
  # and if no other client is connected to the main session attach to it
  if [ -z $TMUX ]; then
    if [ -z "$(tmux list-clients -t "main")" ]; then
      tmux attach -t main 2>/dev/null
    fi
  fi
fi

# Enables (or installs if not installed yet) the Zinit plugin manager for zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Enable zinit plugins
zinit light zsh-users/zsh-completions
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

function zvm_config() {
  # Use system clipboard (wl-copy)
  ZVM_SYSTEM_CLIPBOARD_ENABLED=true

  # Set custom cursors for each vi mode
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
  ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
  ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK

  # Set custom colors for highlight (visual-mode)
  ZVM_VI_HIGHLIGHT_FOREGROUND=0
  ZVM_VI_HIGHLIGHT_BACKGROUND=2
  ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold,underline
}

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Enable Oh-My-zsh plugins
zinit snippet OMZP::sudo

zinit cdreplay -q

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"

# History tweaks
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion tweaks
setopt globdots
setopt extendedglob
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -A -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -A -1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-(commit|add|diff|restore):*' fzf-preview \
  'git diff $realpath | delta --syntax-theme=base16'

# Aliases
alias aurora='for code in {000..18}; do print -P -- "$code: %F{$code}Color%f"; done'
alias upmirrors='sudo reflector --country IT --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist'

alias l='eza -lh --icons=auto'                                         # long list
alias ls='eza --icons=auto'                                            # short list
alias la='eza -A --icons=auto'                                         # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto'                                       # long list dirs
alias lt='eza --icons=auto --tree'                                     # list folder as tree
alias lta='eza -a --icons=auto --tree'                                 # list folder as tree
alias ltt='eza --icons=auto --tree --level 1'                          # list folder as tree
alias ltta='eza -a --icons=auto --tree --level 1'                      # list folder as tree

alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias exp='yay -D --asexplicit'
alias in='yay -Sy'
alias iny='yay -Sy --noconfirm'
alias un='yay -R'
alias purge='yay -Rns'
alias up='yay -Syu'
alias orphans='yay -Qqtd'

alias unstow='stow -D'

alias v='nvim'
alias vim='nvim'

alias j='just'

alias open='xdg-open'

# Config files shortcuts
alias zconf='nvim $HOME/.zshrc'
alias kittyconf='nvim $HOME/.config/kitty/kitty.conf'
alias nvconf='nvim $HOME/.config/nvim'

alias rsy='rsync -ahP'

alias nvims='sudoedit'
alias mkdir='mkdir -p'
alias rf='rm -rf'
alias lsk='lsblk'

alias slowwifi='sudo tc qdisc add dev wlp0s20f0u11 root netem delay 500ms'
alias resetwifi='sudo tc qdisc del dev wlp0s20f0u11 root netem'

alias espidf="source $HOME/.esp/esp-idf/export.sh &> /dev/null"

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias mount='sudo mount'
alias umount='sudo umount'

alias mux='tmuxinator'

alias -g NE='2>/dev/null'
alias -g NS='>/dev/null'
alias -g NO='>/dev/null 2>&1'
alias -g C='| wl-copy'

p() {
  local dir
  # Find directories, strip the ./ and pipe to fzf
  dir=$(find ~/Projects -maxdepth 2 -type d | sed "s|^$HOME/Projects/||" | fzf --header="Select Project")

  # Only jump if we actually picked something (didn't hit ESC)
  if [ -n "$dir" ]; then
    cd "$HOME/Projects/$dir"
  fi
}

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt >/dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
eval "$(mise activate zsh)"
eval "$(pay-respects zsh)"
export _PR_AI_DISABLE

function zvm_after_init() {
  FZF_CTRL_T_COMMAND= source <(fzf --zsh)
  bindkey -M viins '^p' history-search-backward
  bindkey -M viins '^n' history-search-forward
  bindkey ' ' magic-space
  bindkey '^R' fzf-history-widget

  # Sesh
  zle -N sesh-sessions
  bindkey -M vicmd '^s' sesh-sessions
  bindkey -M viins '^s' sesh-sessions
}

# Manpager with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_THEME=base16

export XDG_DESKTOP_DIR=$(xdg-user-dir DESKTOP)
export XDG_DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)
export XDG_TEMPLATES_DIR=$(xdg-user-dir TEMPLATES)
export XDG_PUBLICSHARE_DIR=$(xdg-user-dir PUBLICSHARE)
export XDG_DOCUMENTS_DIR=$(xdg-user-dir DOCUMENTS)
export XDG_MUSIC_DIR=$(xdg-user-dir MUSIC)
export XDG_PICTURES_DIR=$(xdg-user-dir PICTURES)
export XDG_VIDEOS_DIR=$(xdg-user-dir VIDEOS)

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# pnpm
export PNPM_HOME="/home/xitonight/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# TexLive
export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"

PATH=~/.console-ninja/.bin:$PATH
export MATUVIM_DIR="/home/xitonight/.matuvim"

export GOPATH=$HOME/.go
export PATH="$GOPATH/bin:$PATH"

# Created by `pipx` on 2026-02-02 13:49:49
export PATH="$PATH:/home/xitonight/.local/bin"

export ANDROID_HOME="/home/xitonight/.Android/Sdk"

# Disable start/stop output control (XON/XOFF)
# disables default ctrl-s / ctrl-q keybinds
stty -ixon

export XIDOTS_DIR="/home/xitonight/Xidots"

if [ -z $SSH_CONNECTION ]; then
    if ! tmux has-session -t "main" 2> /dev/null; then
        tmux new-session -d -s "main" -n "conf" -c $XIDOTS_DIR # 2> /dev/null
        tmux neww -n "main" -t "main:2" 2> /dev/null
        tmux neww -n "yay" -t "main:3" 2> /dev/null
        tmux neww -d -n "ssh" -t "main:0" 2> /dev/null
    fi
    if [ -z $TMUX ]; then
      if [ -z "$(tmux list-clients -t "main")" ]; then
        tmux attach -t main 2> /dev/null
      fi
    fi
fi

nitch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enables (or installs if not installed yet) the Zinit plugin manager for zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d $ZINIT_HOME ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Source fzf theme
source $HOME/.zsh/fzf_theme

# Enable the p10k zsh prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Enable zinit plugins 
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_VI_EDITOR=nvim

# Enable Oh-My-zsh plugins
zinit snippet OMZP::sudo

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History tweaks
HISTSIZE=5000
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -A --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -A --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -A --color=always $realpath'
zstyle ':fzf-tab:complete:timg:*' fzf-preview 'timg -pk $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'

# Aliases
alias l='eza -lh --icons=auto' # long list
alias ls='eza --icons=auto' # short list
alias la='eza -A --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree

alias exp='yay -D --asexplicit'
alias in='yay -Sy --noconfirm'
alias un='yay -R'
alias purge='yay -Rns'
alias up='yay -Syu'

alias stow='stow'
alias unstow='stow -D'

# Config files shortcuts
alias zconf='nvim $HOME/.zshrc'
alias kittyconf='nvim $HOME/.config/kitty/kitty.conf'
alias nvimconf='nvim $MATUVIM_DIR'

alias nvims='sudoedit'
alias mkdir='mkdir -p'
alias rf='rm -rf'
alias lsk='lsblk'
alias f='fuck'

alias espidf="source $HOME/.esp/esp-idf/export.sh &> /dev/null"

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias mount='sudo mount'
alias umount='sudo umount'

# Manpager with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Change default editor to neovim
export EDITOR=nvim
export VISUAL=nvim 

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
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# pnpm
export PNPM_HOME="/home/xitonight/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Source nvm
source /usr/share/nvm/init-nvm.sh

# TexLive
export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"

PATH=~/.console-ninja/.bin:$PATH
export MATUVIM_DIR="/home/xitonight/.matuvim"

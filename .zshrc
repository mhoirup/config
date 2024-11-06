if [ ! -f "$HOME/.zshrc" ]; then
  echo "source .config/.zshrc" > "$HOME/.zshrc"
fi

function kitty_settings_tab() {
  if [ "$TERM" = 'xterm-kitty' ]; then
    if kitty @ ls | grep -q '"title": "Settings"'; then
      kitty @ focus-window --match title:Settings
    else
      tab_id=$(kitty @ launch --type=tab --cwd=$HOME/.config --title='Settings' nvim)
    fi
  fi
}

alias vim=nvim
alias vnim=nvim
alias ls='ls -lf'

if [ "$TERM" = "xterm-kitty" ]; then
  kitty @ set-window-title " "
  kitty @ set-tab-title " "
fi

autoload -U colors && colors
PS1="%{$fg[blue]%}%B%~ %{$reset_color%}% "

LS_COLORS="di=1;31"


# Install pyenv from git with `git clone https://github.com/pyenv/pyenv.git ~/.pyenv`
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4c566a'
ZSH_AUTOSUGGEST_STRATEGY=(completion)

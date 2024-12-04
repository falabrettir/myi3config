# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:/snap/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# --------------------------------------------------------------------------------------
# Customização do prompt
function set_bash_prompt() {
  # Color codes for easy prompt building
  COLOR_DIVIDER="\[\e[30;1m\]"
  COLOR_CMDCOUNT="\[\e[34;1m\]"
  COLOR_USERNAME="\[\e[34;1m\]"
  COLOR_USERHOSTAT="\[\e[34;1m\]"
  COLOR_HOSTNAME="\[\e[34;1m\]"
  COLOR_GITBRANCH="\[\e[33;1m\]"
  COLOR_VENV="\[\e[33;1m\]"
  COLOR_GREEN="\[\e[32;1m\]"
  COLOR_PATH_OK="\[\e[35;1m\]"
  COLOR_PATH_ERR="\[\e[31;1m\]"
  COLOR_NONE="\[\e[0m\]"
  # Change the path color based on return value.
  if test $? -eq 0; then
    PATH_COLOR=${COLOR_PATH_OK}
  else
    PATH_COLOR=${COLOR_PATH_ERR}
  fi
  # Set the PS1 to be "[workingdirectory:commandcount"
  PS1="${COLOR_DIVIDER}[${PATH_COLOR}\w${COLOR_DIVIDER}]"
  # Add git branch portion of the prompt, this adds ":branchname"
  if ! git_loc="$(type -p "$git_command_name")" || [ -z "$git_loc" ]; then
    # Git is installed
    if [ -d .git ] || git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      # Inside of a git repository
      GIT_BRANCH=$(git symbolic-ref --short HEAD)
      PS1="${PS1} ${COLOR_GITBRANCH}(${COLOR_GITBRANCH}${GIT_BRANCH}${COLOR_GITBRANCH})"
    fi
  fi
  # Add Python VirtualEnv portion of the prompt, this adds ":venvname"
  if ! test -z "$VIRTUAL_ENV"; then
    PS1="${PS1} ${COLOR_VENV}$(basename \"$VIRTUAL_ENV\")"
  fi
  # Close out the prompt, this adds "]\n[username@hostname] "
  PS1="${PS1}\n${COLOR_USERNAME} >${COLOR_NONE} "
}

# Tell Bash to run the above function for every prompt
export PROMPT_COMMAND=set_bash_prompt

# alias
alias vi="nvim"
alias la="ls -a"
alias lr="ls -R"
alias c="xclip -selection clipboard"
alias v="xclip -o"
alias icat="kitten icat"
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

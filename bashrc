# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# If we're running interactively (such as through rsync, sftp etc) don't execute the following code
if [[ $- != *i* ]]; then
  return
fi

# Encoding help?
export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

# Test to ensure we have tmux before automatically executing it..
#if which tmux 2>&1 >/dev/null; then
  # If we're not in a tmux session already open one up that will automatically close when we exit or detach
#  if [[ "$TERM" != "screen" ]]; then
    #tmux && exit 
#  fi
#fi

# Source all executable files that live the system-specific folder
for FILE in $HOME/.dotfiles/system-specific/*; do
  if [[ -x "$FILE" ]]; then
    source $FILE
  fi
done

alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset%s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gs='git status'

# Function that allows some quick directory traversing
function go {
  if [[ "$1" = "b" ]]; then
    popd > /dev/null
  elif [[ "$1" = "rp" ]]; then
    pushd $HOME/ruby_projects > /dev/null
  elif [[ "$1" = "dot" ]]; then
    pushd $HOME/.dotfiles > /dev/null
  else
    pushd $HOME > /dev/null
  fi
}

# Source the git-completion file
source $HOME/.dotfiles/helpers/git-completion.sh

# Some color definitions
RED='\033[0;31m'
YELLOW='\033[1;32m'
GREEN='\033[1;32m'

RST='\033[0m'

#SUCCESS="$GREEN$(echo -e '\xE2\x9C\x93')$RST"
SUCCESS="+"
FAIL="-"

GITPS1="\$(__git_ps1 \" $YELLOW%s$RST\")"

function gitbranch {
        echo -e "${YELLOW}$(__git_ps1)${RST}"
}

function exit_status {
        EXITSTATUS="$?"

        if [ "${EXITSTATUS}" -eq "0" ]; then
                echo -e $SUCCESS
        else
                echo -e $FAIL
        fi
}

function ps1smarts {
        STAT=$(exit_status)
        GIT=$(gitbranch) #Not available on dreamhost :-/
        DIR=$($HOME/.dotfiles/bin/shortdir)

        echo -e "$DIR$GIT $STAT "
}

# For when I inevitable break my PS1...
if [[ -n "$TMUX_PANE" ]]; then
  export PS1="\$(ps1smarts)"
else 
  export PS1="[\u@\h] \$(ps1smarts)"
fi

# Load RVM up
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# RVM doesn't always seem to come up properly for me, this does the trick
rvm reload > /dev/null


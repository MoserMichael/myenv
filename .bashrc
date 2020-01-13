# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH:"
fi
PATH="$PATH:$HOME/go/bin:$HOME/.cargo/bin"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

### path ####

export PATH="$PATH:/home/mmoser/minishift/minishift-1.34.1-linux-amd64"


### $(minishift oc-env) tells us to add this to the path
export PATH="/home/mmoser/.minishift/cache/oc/v3.11.0/linux:$PATH"


### HISTORY ####

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# unlimited history in bash (don't want to forget these setup commands...)
HISTSIZE= 
HISTFILESIZE=

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000

########
alias lsd='ls -al | grep ^d'
alias e='vim'
alias ebig='vim -u NONE'
alias m='make'
alias gb='git branch'

export EDITOR=vim


alias topmem='top -o %MEM'

# show origin of branch
alias gorigin='git rev-parse --abbrev-ref --symbolic-full-name @{u}'

# grep in git files (actually this is stupid - there is git grep)
gitgrep()
{
    # find the top level directory for this git repository
    TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
    if [ "x$TOP_DIR" != "x" ]; then
        pushd $TOP_DIR >/dev/null
        # search in all files, they are now relative to repo root dir; so prepend the repo dir to get full path
        git ls-files -z | xargs -0 grep $* | while IFS= read -r line; do printf '%s/%s\n' "$TOP_DIR" "$line"; done
        popd >/dev/null
    else 
        echo "$PWD is not a git repo"
    fi
}


# if argument exists in one man page - call man <argument>
# if argument exists in more than one man page - promt user for a choice of man page, then call man with the argument
function h
{
    local sterm
    local tmpfile
    local mpages
    local mpagecount

    sterm=$*
    tmpfile=$(mktemp /tmp/sshtonode.XXXXXX)                                                                                                                                                                                                       mpagecount=0

    for m in 1 2 3 4 5 6 7 8 9; do
        man $m searchterm $sterm >$tmpfile 2>/dev/null
        fsize=$(stat --printf="%s" $tmpfile)
        if [[ $fsize != 0 ]]; then
            mpages="$mpages $m"
            ((mpagecount += 1))
        fi
        rm -f $tmpfile
    done

    if [ $mpagecount == 0 ]; then
       echo "* no page found *"
    else
       if [[ $mpagecount > 1 ]]; then 
          echo "select page: $mpages"
        
          local page

          echo -n "> "
          read page
        
          man $page $sterm
       else
          man $sterm
       fi
    fi
}
mergetwocommits()
{
    git rebase --interactive HEAD~2
}

#
# git log as tree
#
alias gitgraph='git log --graph --full-history --all --color         --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

#
# who are the most frequent authors in the current git repository?
#
alias whoisauthor="git log | grep 'Author: ' | sort  | uniq -c | sort -k1rn | less"


#
# show all sort of stuff about the current git repository
#
aboutgitarchive() 
{
    cat | less <<EOF
Origin url: $(git config --get remote.origin.url)
# of files in repo $(git ls-files | wc -l)
First commit: $(git log | grep '^Date:' | tail -1)
last commit:  $(git log | grep '^Date:' | head -1)
# of comits in archive: $(git log | grep ^commit | wc -l)
# of commits with authors with redhat.com:    $(git log | grep 'Author: ' | sort  | uniq -c | sort -k1rn | grep  redhat.com | awk '{sum+=$1} END {print sum}')
# of commits with authors from other domains: $(git log | grep 'Author: ' | sort  | uniq -c | sort -k1rn | grep  -v redhat.com | awk '{sum+=$1} END {print sum}')
frequent authors:           
$(git log | grep 'Author: ' | sort  | uniq -c | sort -k1rn)
EOF


}

# grep in cpp sources
s()
{
  find . -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.h' \) -print0 2>/dev/null | xargs -0 grep $*
}

sa()
{
  find . -type f -name '*' -print0 2>/dev/null | xargs -0 grep $*
}

findgomain()
{
    #find -name '*.go' | xargs egrep -e "func[[:space:]]*main"
    find -name '*.go' -print0 | xargs -0 egrep -e "func[[:space:]]*main[[:space:]]*\("
}



# grep in python files
p()
{
  find . -name '*.py' -print0 2>/dev/null | xargs -0 grep $*
}


# build ctags
ctg()
{
  # find the top level directory for this git repository
  TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
  if [ "x$TOP_DIR" != "x" ]; then
      pushd $TOP_DIR >/dev/null
      rm tags 2>/dev/null
      find . -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.h' \) | xargs ctags -a --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++   
      popd >/dev/null 
  else 
      find . -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.h' \) | xargs ctags -a --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++   
  fi
}

gotags() {
  # find the top level directory for this git repository
  TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
  if [ "x$TOP_DIR" != "x" ]; then
      pushd $TOP_DIR >/dev/null
      rm tags 2>/dev/null
      find . -type f \( -name '*.go' \) -print0 | xargs -0 /usr/bin/gotags >tags     
      popd >/dev/null 
  else 
      find . -type f \( -name '*.go' \) -print0 | xargs -0 /usr/bin/gotags >tags     
  fi
}  




# delete everything in docker registry 
dockerclean() 
{
    echo "*** stop all docker containers ***"
    docker stop $(docker ps -a -q)

    #https://stackoverflow.com/questions/44785585/how-to-delete-all-docker-local-docker-images

    echo "*** delete all containers ***"
    docker rm -vf $(docker ps -a -q)

    echo "*** delete all imagess ***"
    docker rmi -f $(docker images -a -q)
}


# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="[\u@\h \W\$(parse_git_branch)]\$ "

# strange: when I log in with the color prompt, then I have to resource the shell, else git branch doesn't display.
#PS1="[\e[0;34m\u@\h\e[m \W\\e[0;35m$(parse_git_branch)\e[m]\$ "

# but don't need to do that with uniform coloring ... as awayls strange hickups upon non-trivial usage...
#PS1="[\e[0;35m\u@\h \W\$(parse_git_branch)\e[m]\$ "

# go stuff
export GO111MODULE=on
export GOPATH=/home/mmoser/go

# fedora
alias fedoraversion='cat /etc/fedora-release'
alias distroversion='cat /etc/*-release'

# tmux

function ta {
    tmux attach -t $1
}

function _ta {
  local cur prev opts f
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  #opts=$(tmux ls -F '#S')
  
  for f in $(tmux ls | awk '{ print $1 }'); do
    f=${f: : -1}
    opts="$opts $f"
  done

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}

complete -F _ta ta

alias tk='tmux kill-session -t'

complete -F _ta tk

alias tls='tmux ls'
alias tn='tmux new -s'


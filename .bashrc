# .bashrc

if [[ "$OSTYPE" == "darwin"* ]]; then
    #local hack on osx.
    if [[ -f $HOME/.bash_profile ]]; then
      . $HOME/.bash_profile
    fi
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


function add_path {
    local arg=$1

    if ! [[ "$PATH" =~ "$arg" ]]; then
        PATH="$PATH:$arg"
    fi
}

add_path "/sbin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/scripts:$HOME/.local/bin/"


export PATH

# set pager to less
export PAGER=less

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# go stuff
#export GO111MODULE=auto

export GOPATH=$HOME/go
#export GOROOT=/usr/lib/golang/bin/
unset  GO111MODULE
#export GO111MODULE="auto"


### 
# HISTORY 
####

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


###
# General stuff
###


straceprefix_usage='put this before command to run strace (put into strace.log)'
alias straceprefix='strace -s 4096 -f -o strace.log '


file2clip_usage='<file> copy file to clipboard'
function file2clip {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     
            cat $1 |  xsel -i -b 
            ;;
        Darwin*)    
            cat $1 |  pbcopy
            ;;
    esac       
 
}

lsd_usage="show directories in current directory only"
alias lsd='ls -al | grep ^d'

e_usage="[<file>] start vim"
alias e='vim'

ebig_usage="[<file>] start vim for editing very big files"
alias ebig='vim -u NONE'

m_usage="alias for running make"

#alias m='make'

function makeIt {
    set -x
    if [[ -f build.gradle ]]; then
        cmd=$1
        if [[ $cmd == "" ]]; then
            ./gradlew cleanTest  test --fail-fast 2>&1 | tee log.log
            #gradle cleanTest build  2>&1 | tee log.log
        else
            ./gradlew "$@" 2>&1 | tee log.log
        fi


    else
        if [[ -f pom.xml ]]; then
            cmd=$1
            if [[ $cmd == "" ]]; then
                mvn compile 2>&1 | tee log.log
            else
                mvn "$@" 2>&1 | tee log.log
            fi
        else 
            if [[ -f Makefile  ]] || [[ -f makefile ]] || [[ -f GNUmakefile ]]; then
                make "$@" 2>&1 | tee log.log
            else 
                echo "don't know how to make this, yet"
                
            fi
        fi
    fi
    set +x
    beep.sh
}

alias m='makeIt'


# want the command line arguments listed in default ps.

old_ps=$(which ps)

function ps() {
   local args="$@"
   if [[ $args == "" ]]; then 
        if [[ "$OSTYPE" == "darwin"* ]]; then
            args="-T -o pid,tname,time,command"
        else
            args="-o pid,tname,time,args"
        fi    
   fi 
   ${old_ps} $args
}

nospaceinfilenames_usage="for files in current dir, rename filenames with spaces, swap spaces with underscores"
alias nospaceinfilenames='for f in *\ *; do mv "$f" "${f// /_}"; done'


#topmem_usage="run top to show processes ordered by memory consumption"
#alias topmem='top -o %MEM'

pstopcpu_usage="list processes with top cpu usage on top (first column in red)"
alias pstopcpu="ps -eo pcpu,pid,user,args | sort -n -k 1 -r | awk '"'{ $1="\033[31m"$1"%\033[0m"; $4="\033[31m"$4"\033[0m"; print }'"' | less -R"


pstopmem_usage="list processes with top memory usage on top (first column in red)"
alias pstopmem="ps -eo vsz,pid,user,args | sort -n -k 1 -r | awk '"'{ $1="\033[31m"$1 / 1000"Mib\033[0m"; $4="\033[31m"$4"\033[0m"; print }'"' | less -R"

#spacetotabs_usage="<filename> four spaces swapped into a tab"
#alias spacetotabs="sed -i -e 's/    /\t/g'"
#alias spacetotabs="expand -t 4 "

alias choplasteof_usage="cut newline at endof file"
alias choplasteof="perl -pi -e 'chomp if eof' "


# fedora
alias fedoraversion='cat /etc/fedora-release'
alias distroversion='cat /etc/*-release'


###
# git stuff
###



if [[ ! -f $HOME/.git-completion.bash ]]; then 
    echo "downloading git completion script ..."
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash
fi
. $HOME/.git-completion.bash

export EDITOR=vim

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="[\u@\h \W\$(parse_git_branch)]\$ "

# strange: when I log in with the color prompt, then I have to resource the shell, else git branch doesn't display.
#PS1="[\e[0;34m\u@\h\e[m \W\\e[0;35m$(parse_git_branch)\e[m]\$ "

# but don't need to do that with uniform coloring ... as awayls strange hickups upon non-trivial usage...
#PS1="[\e[0;35m\u@\h \W\$(parse_git_branch)\e[m]\$ "


gitdiff_usage="show git difftool with vim"
alias gitdiff="git difftool -y --tool=vimdiff"

#gitdiff_usage="git diff with line numbers!"
#
##
## from https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers
##
#gitdiff() {
#    git diff $* | gawk 'match($0,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
#   /^(---|\+\+\+|[^-+ ])/{print;next};\
#   {line=substr($0,2)};\
#   /^-/{print "-" left++ ":" line;next};\
#   /^[+]/{print "+" right++ ":" line;next};\
#   {print "(" left++ "," right++ "):"line}'
#}      
#
#gitdiffc_usage="git diff with colors and line numbers!"
#
##
## from https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers
##
#gitdiffc() {
#    git diff --color=always $* | \
#    gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
#      match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
#      bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
#      {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
#      bare~/^-/{print "-"left++ ":" line;next};\
#      bare~/^[+]/{print "+"right++ ":" line;next};\
#      {print "("left++","right++"):"line;next}' | less -R
#}

gb_usage="show current git branch"
alias gb='git branch -vv' 

gorigin_usage="show origin of branch"
alias gorigin='git rev-parse --abbrev-ref --symbolic-full-name @{u}' 


gitstatall_usage="git status does not show all files (thosed in .ignored are not shown) this one shows them all."
alias gitstatall='git status --ignored'

giturl_usage="show url that this git repo is looking at"
alias giturl='git remote -v'

gitlog_usage='show git log with status of change (like svn)'
alias gitlog='git log --name-status --find-renames'

gitlogcompact_usage='show git log -p - only changed lines'
alias gitlogcompact='git log -p | grep -E "^\+|^\-|^commit|^Author:|^Date:"'

gitshowdeleted_usage="show deleted files in git"
alias gitshowdeleted='git log --diff-filter=D --summary | grep "delete mode"'

gitundodelete_usage="<file>  bring back a deleted file in git"
gitundodelete() {
  local bringbackfile=$1
  
  set -x
  commit=$(git rev-list -n 1 HEAD -- $bringbackfile)
  if [[ $? == 0 ]]; then
	git checkout ${commit}~1 $bringbackfile
  fi
  set +x
}

mergetwocommits_usage="merge the last two commits"

mergetwocommits()
{
    git rebase --interactive HEAD~2
}
mergencommits_usage="<number> merge a number of the last <number> commits"

mergencommits()
{
    git rebase --interactive HEAD~$1
}

gitcleanuntracked_usage="clean all untracked files and directories"

alias gitcleanuntracked='git clean -f; git clean -f -d'

gitgraph_usage="git log as tree"

alias gitgraph='git log --graph --full-history --all --color         --pretty=format:"%an %x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s" | less -R'
alias gitgraph2='git log --graph --full-history --all  --pretty=format:"%an %x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s" | less -R'


gpush_usage="some projects at redhat force you to add a sign-off to each commit; this automates the process."

function gpush {
  local my_email
  local my_user
  local last_message
  
  my_user=$(git config --global user.name)
  my_email=$(git config --global user.email)
  if [[ "${my_email}" != "" ]] && [[ "${my_user}" != "" ]]; then

	# add sign-off message to the last commit.
        last_message=$(git log -1 --pretty=%B)
	msg=$(cat <<EOF
${last_message}

Signed-off-by: ${my_user} <${my_email}>
EOF
)

	git commit --amend -m "$msg"
	git push $*
  else
	echo 'gpush works only if you configured your email and user with $(git config --global user.email <your-email>) $(git config --global user.name <your-name>)'
  fi
}

whoisauthor_usage="show who are the most frequent authors in the current git repository"

function whoisauthor() {
    git log $1 | grep 'Author: ' | sort  | uniq -c | sort -k1rn | less
}

gitfilesincommit_usage="<commit-sha>  to show files in commit"

alias gitfilesincommit="git diff-tree --no-commit-id --name-only -r "

gittar_usage="create tar gz of git repo in current dire. default output file: backup.tar.gz"

gittar() 
{
    file=$1
    if [[ $file -eq "" ]]; then
        file=backup.tar.gz
    fi
    git ls-files -z | tar -czvf $file --null -T -
}

gitgrep_usage="<search-term> run git grep from the repositories root directory - and put in full path name on all matching files."

gitgrep()
{
    local TOP_DIR

    # find the top level directory for this git repository
    TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
    if [ "x$TOP_DIR" != "x" ]; then
        pushd $TOP_DIR >/dev/null
        # search in all files, they are now relative to repo root dir; so prepend the repo dir to get full path
        #git ls-files -z | xargs -0 grep $* | while IFS= read -r line; do printf '%s/%s\n' "$TOP_DIR" "$line"; done
        
        # no all the colors of git grep output are gone after pipng them through the next stage....
        git --no-pager grep $* | while IFS= read -r line; do printf '%s/%s\n' "$TOP_DIR" "$line"; done
        popd >/dev/null
    else 
        echo "$PWD is not a git repo"
    fi
}

gitgrepall_usage="<search-term> run git grep from the repositories root directory in all remote branches!"

gitgrepall() {
    local TOP_DIR

    # find the top level directory for this git repository
    TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
    if [ "x$TOP_DIR" != "x" ]; then
        pushd $TOP_DIR >/dev/null
        
        git grep -i $* `git for-each-ref --format='%(refname)' refs/`
        
        popd >/dev/null
    else 
        echo "$PWD is not a git repo"
    fi
}

s_usage="<search-term> grep alias for searching in cpp files under current directory"

s()
{
  find . -type f \( -name '*.cpp' -o -name '*.cxx' -o -name '*.hpp' -o -name '*.hxx' -o -name '*.h' \) -print0 2>/dev/null | xargs -0 grep $*
}

sa_usage="<search-term> grep alias for searching in all files under current directory"

sa()
{
  find . -type f -name '*' -print0 2>/dev/null | xargs -0 grep $*
}

sg_usage="<search-term> grep alias for searching in all go source files under current directory"

sg()
{
  find . -type f \( -name '*.go' -o -name go.mod \) -print0 2>/dev/null | xargs -0 grep $*
}

p_usage="<search-term> grep alias for searching in python files under current directory"

p()
{
  find . -name '*.py' -print0 2>/dev/null | xargs -0 grep $*
}


findgomain_usage="find main functions in go source files (looking for entry point when looking at stuff)"

findgomain()
{
    find . -name '*.go' -print0 | xargs -0 egrep -e "func[[:space:]]*main[[:space:]]*\("
}

findcppmain_usage="find main functions in c++ source files (entry point when looking at stuff)"

findcppmain()
{
    find -name \('*.cpp' -o -name '*.cxx'\) -print0 | xargs -0 egrep -e "int[[:space:]]*main[[:space:]]*\("
}

errno_usage='<error number> greps up the error code in include files under /usr/ (reason is in comment displayed)'

function errno() {
    local arg=$1
    find /usr -type f -name '*errno*.h'  2>/dev/null | xargs grep -E '[[:space:]]'$arg'[[:space:]]'
}


###
# tags
###

ctg_usage="build ctags for all c++ source files under current direcory"

ctg()
{
  local TOP_DIR

  # find the top level directory for this git repository
  TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
  if [ "x$TOP_DIR" != "x" ]; then
      pushd $TOP_DIR >/dev/null
      rm tags 2>/dev/null
      find . -type f \( -name '*.cpp' -o -name '*.cxx' -o -name '*.hpp' -o -name '*.hxx' -o -name '*.h' \) | xargs ctags -a --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++   
      popd >/dev/null 
  else 
      find . -type f \( -name '*.cpp' -o -name '*.cxx' -o -name '*.hpp' -o -name '*.hxx' -o -name '*.h' \) | xargs ctags -a --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++   
  fi
}

gotags_usage="build tags for all go source files under current direcory"

gotags() 
{
  local TOP_DIR
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


#h_usage="<term>  show man page for <term>; prompt for man page if multiple pages for <term>"
#function h
#{
#    local sterm
#    local tmpfile
#    local mpages
#    local mpagecount
#
#    sterm=$*
#    tmpfile=$(mktemp /tmp/sshtonode.XXXXXX)
#    mpagecount=0
#
#    for m in 1 2 3 4 5 6 7 8 9; do
#        man $m searchterm $sterm >$tmpfile 2>/dev/null
#        fsize=$(stat --printf="%s" $tmpfile)
#        if [[ $fsize != 0 ]]; then
#            mpages="$mpages $m"
#            ((mpagecount += 1))
#        fi
#        rm -f $tmpfile
#    done
#
#    if [ $mpagecount == 0 ]; then
#       echo "* no page found *"
#    else
#       if [[ $mpagecount > 1 ]]; then 
#          echo "select page: $mpages"
#        
#          local page
#
#          echo -n "> "
#          read page
#        
#          man $page $sterm
#       else
#          man $sterm
#       fi
#    fi
#}
#
###
# docker or kubernetes
###


#
dockerrunimagebash_usage="<docker-image> run a docker image and get you a shell with a contaiener using that image (if image has bash) mount user dir to /mnt/myhome"

function dockerrunimagebash {
    echo "... Mounting home directory to /var/home"
    docker run -it --entrypoint /bin/bash -v $HOME:/var/home $1
}


dockerimagels_usage="<docker image>; list content of docker image without running the container. (preferable)"

function dockerimagels {
    local IMAGE CONTAINER_ID

    IMAGE=$1
    CONTAINER_ID=$(docker create $IMAGE)
    docker export  $CONTAINER_ID | tar tvf -
    docker rm $CONTAINER_ID
}

dockerimageget_usage="<docker image> <tarfile> copies content of image into tar file."

function dockerimageget {
    local IMAGE CONTAINER_ID FILE

    IMAGE="$1"
    FILE="$2"

    CONTAINER_ID=$(docker create $IMAGE)
    docker export  $CONTAINER_ID >${FILE}
    docker rm $CONTAINER_ID
}



dockerimagesizes_usage="show size of docker images in human readable form"

alias dockerimagesizes='docker system df -v'

dockerclean_usage="delete everything in docker registry"

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

dockercleanunnamed_usage="clean out unused stuff to free up disk space."

dockercleanunnamed() 
{
    #docker images | sed '1d' | awk '{ print $1 "" $2 " " $3 }' | grep -F '<none><none>' | awk '{ print $2 }' | xargs docker image rm -f 2>/dev/null
    
    # official docker cleanup command.
    #docker system prune -af

    #delete dangling or orphanded volumes
    docker volume rm $(docker volume ls -qf dangling=true)

    #delete dangling or untagged images
    docker rmi $(docker images -q -f dangling=true)

    #delete exited containers 
    docker rm $(docker ps -aqf status=exited)
}


#dockercontainerrm_usage="force remove all docker containers"

#alias dockercontainerrm="docker container ls --all  | sed -e '1d' | awk '{ print $1 }' | xargs docker rm -f "

dockerstopall_usage="stop & remove all docker containers"

alias dockerstopall='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)'

showunhealthypods_usage="show only pods that are not quite well."

alias showunhealthypods='oc get pods -A | grep -v -E "Completed|Running"'

###
# tmux
###

alias ta_usage="<session-name> run a tmux session (with completion"

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

tk_usage="<session-name> kill a tmux session (with completion)"

alias tk='tmux kill-session -t'

complete -F _ta tk

tls_usage="lists all tmux sessions"
alias tls='tmux ls'

tn_usage="<session-name> creates a new tmux session"
alias tn='tmux new -s' 


###
# anything else?
###

function banner_simple 
{
    # show a fortune cookie in a random ascii blurb. (but only as interactive shell)
    if [[ ! -z "$PS1" ]]; then 
       fortune | cowsay -p -f $(cowsay -l | sed '1d' | tr ' ' '\n' | shuf -n 1 | awk '{ print $1 }')
    fi
}

# tell git to remember the password.
#git config --global credential.helper 'cache --timeout=100000000'

#got tired of this banner business. don't need it.
#banner_simple

show_usage="show help text on all utility aliases/functions that have <name>_usage variable defined"

function show_impl {
    local myaliases myscripts mystuff line helpenv

    mystuff=$(compgen -a -A function |grep -E "^([[:alpha:]]|[[:digit:]]|_)*$" | sort)

    while IFS= read -r line; do 
        helpenv="${line}_usage"
        if [[ "${!helpenv}" != "" ]]; then
            printf "%20s %s\n" "${line}" "${!helpenv}"
        fi
    done <<< "$mystuff"

    echo ""
    echo "** scripts ***"
    echo ""

    myscripts=$(ls ~/scripts | sort)
    for f in $(ls ~/scripts); do 
        printf "%20s: %s\n" "${f}" "$(export SHORT_HELP_MODE=1; $f -h)"
    done
}

alias show="bash -ci 'show_impl' | less"


# check if in interactive mode (not from bash profile)
if [ -t 1 ]; then
    # don't want Ctr-S make the display freeze (can unfreeze with Ctrl+Q)
    stty -ixon
    #stty -ixany
fi

function _less {
    local arg="$1"
    if [[ "$arg" == "-R" ]]; then
        less -R
    else 
        vim - 
    fi
}

alias less=_less


function _follow-kube-logs {
    local cur opts

    export COMP_CWORD
    export COMP_LINE
    opts=$(follow-kube-logs.py -c -k kubectl )
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _follow-kube-logs follow-kube-logs.py

# when possible.
#syntax on

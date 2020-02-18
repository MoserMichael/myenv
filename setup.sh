#!/bin/bash

set -xe

MODE="$1"

function install {
    from="$1"
    to="$2"

    if [ -f "$to" ]; then
        cp "$to" "$to.backup-setup-env"
    fi  

    cp -f "$from" "$to"
}


echo "*** os version ***"
cat /etc/os-release

echo "*** install packages ***"
IS_FEDORA=$(cat /etc/os-release | grep -i fedora | wc -l)

if [[ "$IS_FEDORA" != "0" ]]; then

    TOOLS_PKG="tmux vim git make jq"
    GO_PKG="golang"
    CPP_PKG="g++ clang valgrind gdb ctags"
    PY_PKG="python3 pylint"
    NET_PKG="openssh openssh-clients curl wget strace nmap tcpdump"
    OTHER_PKG="ShellCheck"

    sudo dnf -y update
    sudo dnf -y install $TOOLS_PKG $GO_PKG $CPP_PKG $PY_PKG $NET_PKG $OTHER_PKG

if [[ "$MODE" != "docker" ]]; then
    sudo dnf -y xsel
fi

else

    IS_UBUNTU=$(cat /etc/os-release | grep -i ubuntu | wc -l)

    if [[ "$IS_UBUNTU" != "0" ]]; then


    VER=$(go version | sed -n 's/go version go\([^[:space:]]*\).*$/\1/p')

    MAJOR_VER=""
    MINOR_VER=""

    if [ "$VER" != "" ]; then
        MAJOR_VER=$(echo "$VER"  | sed -n 's/\([[:digit:]]\+\)\.\([[:digit:]]\+\).*$/\1/p')
        MINOR_VER=$(echo "$VER"  | sed -n 's/\([[:digit:]]\+\)\.\([[:digit:]]\+\).*$/\2/p')
    fi

    # require at least 1.13
    if [[ $MAJOR_VER -gt 1 ]] || [[ $MINOR_VER -ge 13 ]]; then
        echo "have at least golang 1.13"
    else
        # no package for golang on ubuntu right now
        apt-get install -qy wget
        wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz -O go.tar.gz
        sha256sum go.tar.gz
        tar -C /usr/local/ -xvzf go.tar.gz
        rm -rf go.tar.gz
        for f in $(ls /usr/local/go/bin/); do
            ln -s /usr/local/go/bin/$f /usr/bin/$f
        done
        go version
    fi

	TOOLS_PKG="tmux vim git make jq"
	GO_PKG="" #golang-1.13"
	CPP_PKG="g++ clang valgrind gdb exuberant-ctags clang-format"
	PY_PKG="python3 pylint"
	NET_PKG="openssh-client curl wget strace nmap tcpdump"
    OTHER_PKG="shellcheck"

	sudo apt-get -qy update
	sudo apt-get install -qy $TOOLS_PKG $GO_PKG $CPP_PKG $PY_PKG $NET_PKG $OTHER_PKG
 
    else
	echo "sorry, your OS/distribution is not supported. Right now it does fedora or ubuntu"
	exit 1
    	
    fi

if [[ "$MODE" != "docker" ]]; then
    sudo apt-get install -qy xsel
fi


fi


pushd $GOPATH
go get -u github.com/jstemmer/gotags
cd src/github.com/jstemmer/gotags
go build
sudo cp gotags /usr/bin
popd

echo "*** setup tmux continuous save/restore ***"

# setup stuff (probably a better way to do that)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect

git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum

# write some clang-format ini file.
clang-format -style=llvm -dump-config > ~/.clang-format


if [[ "$MODE" != "docker" ]]; then

install .tmux.conf ~/.tmux.conf
install .bashrc   ~/.bashrc
install .vimrc    ~/.vimrc

cat <<EOF
*** tmux save/restore ***
in tmux 
echo "*** setup environment completed ***"
 
Ctl+b I      : reload tmux env (first time)
Ctrl+b Ctl+s : save
Ctl+b  Ctl+r : restore

*** setup environment completed ***
EOF
 
fi

# install the youcompleteme plugin/vundle/etc.

# get vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

ls ~/.vim/bundle/Vundle.vim

# required stuff 
if [[ "$IS_FEDORA" != "0" ]]; then
   sudo dnf -y install cmake gcc-c++ make python3-devel nodejs
else
    if [[ "$IS_UBUNTU" != "0" ]]; then
       sudo apt-get install -qy build-essential cmake python3-dev nodejs
    
       echo "install npm"
       curl -L https://npmjs.org/install.sh | sudo sh
    fi
fi

vim --version

vim +PluginInstall +qall
#vim -c MyPInstall


# build completion server
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all

echo "*** everything set up ***"



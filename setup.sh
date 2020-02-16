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



echo "*** install packages ***"

cat /etc/os-release

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

	TOOLS_PKG="tmux vim git make jq"
	GO_PKG="golang"
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
    fi
fi

vim --version

vim +PluginInstall +qall
#vim -c MyPInstall


# build completion server
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all

echo "*** everything set up ***"



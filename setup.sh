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

    sudo dnf -y install tmux vim git make

    sudo dnf -y install golang 

    sudo dnf -y install g++ clang valgrind gdb ctags

    sudo dnf -y install python3
    
    sudo dnf -y install jq ssh curl wget strace nmap tcpdump

fi

IS_UBUNTU=$(cat /etc/os-release | grep -i ubuntu | wc -l)

if [[ "$IS_UBUNTU" != "0" ]]; then

    sudo apt-get -qy update

    sudo apt-get install -qy tmux vim git make

    sudo apt-get install -qy golang 

    sudo apt-get install -qy g++ clang valgrind gdb exuberant-ctags clang-format

    sudo apt-get install -qy python3
	
    sudo apt-get install -qy jq ssh curl wget strace nmap tcpdump


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

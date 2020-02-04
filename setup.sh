#!/bin/sh

set -x

function install {
    from="$1"
    to="$2"

    if [ -f "$to" ]; then
        cp "$to" "$to.backup-setup-env"
    fi  

    cp -f "$from" "$to"
}


CNT=$(cat /etc/os-release | grep Fedora | wc -l)
if [ $CNT != 0 ]; then 
    TYPE=fedora
else
    echo "unsupported for now"
    exit 1
fi



echo "*** install packages ***"

sudo dnf -y install tmux vim git

sudo dnf -y install golang gotags 

sudo dnf -y install g++ clang valgrind gdb ctags

sudo dnf -y install python3

echo "*** setup tmux continuous save/restore ***"

# setup stuff (probably a better way to do that)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/tmux-plugins/tmux-resurrect ~/clone/path

git clone https://github.com/tmux-plugins/tmux-continuum ~/clone/path

install .tmux.conf ~/.tmux.conf
install .bashrc   ~/.bashrc
install .vimrc    ~/.vimrc

# write some clang-format ini file.
clang-format -style=llvm -dump-config > ~/.clang-format

cat <<EOF
*** tmux save/restore ***
in tmux 

Ctl+b I      : reload tmux env (first time)
Ctrl+b Ctl+s : save
Ctl+b  Ctl+r : restore
EOF


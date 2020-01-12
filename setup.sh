#!/bin/sh

set -x

CNT=$(cat /etc/os-release | grep Fedora | wc -l)
if [ $CNT != 0 ]; then 
    TYPE=fedora
else
    echo "unsupported for now"
    exit 1
fi

echo "*** install packages ***"
sudo dnf -y install tmux vim ctags gotags git g++

echo "*** setup tmux continuous save/restore ***"

# setup stuff (probably a better way to do that)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/tmux-plugins/tmux-resurrect ~/clone/path

git clone https://github.com/tmux-plugins/tmux-continuum ~/clone/path

cp -f .tmux.conf ~/.tmux.conf


cat <<EOF
*** tmux save/restore ***
in tmux 

Ctl+b I      : reload tmux env (first time)
Ctrl+b Ctl+s : save
Ctl+b  Ctl+r : restore
EOF


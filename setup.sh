#!/bin/sh

set -x


echo "*** setup tmux continuous save/restore ***"

sudo dnf -y install tmux

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


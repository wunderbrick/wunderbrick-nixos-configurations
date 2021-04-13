#!/bin/sh

rsync -r --chmod=u+rwx,g+r,o+r ../shared/dotfiles/eww/* awp@192.168.10.157:~/.config/eww
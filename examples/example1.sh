#!/bin/bash
. ../scripter.sh
clear
export LC_ALL=C
rm -f newfile

cowsay -W 30 "This is a demo of the 'touch' and 'rm' commands"
sleep 3
clear
cowsay -W 30 "Prior knowledge of the 'ls' command is required"
sleep 3
clear

prompt "[example1]$ "
pe "ls"
pe "ls newfile"
pe "touch newfile"
pe "ls"
sleep 3 # Give the audience a bit more time to take it in
pe "rm newfile"
pe "ls"


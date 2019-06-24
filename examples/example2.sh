#!/bin/bash
. ../scripter.sh
clear

prompt "[${RED}example2${CRESET}]$ "

pe "whoami"
pe "ls"

p "format c:" # Fake it
echo "Formatting..."
sleep 5
echo "25%"
sleep 5
echo "50%"
sleep 5
echo "75%"
sleep 5
echo "Done"
prompt # 'pe' will redraw prompt on its own, 'p' can't

# TODO: more realistic error
p "whoami"
echo "ext4-fs error ext4_lookup deleted inode referenced"
prompt

# TODO: more realistic error
p "ls"
echo "ext4-fs error ext4_lookup deleted inode referenced"
prompt


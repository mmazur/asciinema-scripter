#!/bin/bash

###############################################################################
#
# Based on demo-magic.sh by Paxton Hare
#
# Gives you the ability to script a whole verbose terminal demo.
# Discover your inner Aaron Sorkin.
#
###############################################################################

# the speed to "type" the text
TYPE_SPEED=14

# if > 0, sleep for this many seconds after each command finishes
AUTO_SLEEP=1

# don't show command number unless user specifies it
SHOW_CMD_NUMS=false

# handy color vars for pretty prompts
BLACK="\033[0;30m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
GREY="\033[0;90m"
CYAN="\033[0;36m"
RED="\033[0;31m"
PURPLE="\033[0;35m"
BROWN="\033[0;33m"
WHITE="\033[1;37m"
COLOR_RESET="\033[0m"

C_NUM=0

# prompt and command color which can be overriden
DEMO_PROMPT="$ "
DEMO_CMD_COLOR=$WHITE
DEMO_COMMENT_COLOR=$GREY

##
# prints the script usage
##
function usage() {
  echo -e ""
  echo -e "Usage: $0 [options]"
  echo -e ""
  echo -e "\tWhere options is one or more of:"
  echo -e "\t-h\tPrints Help text"
  echo -e "\t-d\tDebug mode. Disables simulated typing"
  echo -e "\t-c\tNumber each command."
  echo -e ""
}

##
# wait for user to press ENTER
#
# takes 1 optional param - max length of time to wait for, in seconds
#
##
function wait() {
  if [[ -n "$1" ]]; then
    read -rst "$1"
  else
    read -rs
  fi
}

# Render the prompt
function prompt() {
  x=$(PS1="$DEMO_PROMPT" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')

  # show command number is selected
  if $SHOW_CMD_NUMS; then
   printf "[$((++C_NUM))] $x"
  else
   printf "$x"
  fi

  if [[ "$AUTO_SLEEP" != "0" ]]; then
    read -rst "$AUTO_SLEEP"
  fi
}

##
# Only print a command. Useful for when you want to pretend to run a command
#
# takes 1 param - the string command to print
#
# usage: p "format c:"
#
##
function p() {
  if [[ ${1:0:1} == "#" ]]; then
    cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  else
    cmd=$DEMO_CMD_COLOR$1$COLOR_RESET
  fi

  if [[ -z $TYPE_SPEED ]]; then
    echo -en "$cmd"
  else
    echo -en "$cmd" | pv -qL $[$TYPE_SPEED+(-2 + RANDOM%5)];
  fi

  echo ""
}

##
# Prints and executes a command
#
# takes 1 parameter - the string command to run
# TODO: second param for delay between last letter and ENTER
#
# usage: pe "ls -l"
#
##
function pe() {
  # print the command
  p "$@"

  # execute the command
  eval "$@"

  prompt
}

##
# Enters script into interactive mode
#
# and allows newly typed commands to be executed within the script
#
# usage : cmd
#
##
function cmd() {
  # render the prompt
  x=$(PS1="$DEMO_PROMPT" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')
  printf "$x\033[0m"
  read command
  eval "${command}"
}


function check_pv() {
  command -v pv >/dev/null 2>&1 || {

    echo ""
    echo -e "${RED}##############################################################"
    echo "# HOLD IT!! I require pv but it's not installed.  Aborting." >&2;
    echo -e "${RED}##############################################################"
    echo ""
    echo -e "${COLOR_RESET}Installing pv:"
    echo ""
    echo -e "${BLUE}Mac:${COLOR_RESET} $ brew install pv"
    echo ""
    echo -e "${BLUE}Other:${COLOR_RESET} http://www.ivarch.com/programs/pv.shtml"
    echo -e "${COLOR_RESET}"
    exit 1;
  }
}

check_pv
#
# handle some default params
# -h for help
# -d for disabling simulated typing
#
while getopts ":hdc:" opt; do
  case $opt in
    h)
      usage
      exit 1
      ;;
    d)
      unset TYPE_SPEED
      ;;
    c)
      SHOW_CMD_NUMS=true
      ;;
  esac
done

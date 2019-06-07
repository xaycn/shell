#!/usr/bin/env bash
#
# Powerful script to meet your needs.
#
# Copyright (C) By Xaycn <Xaycn@outlook.com>
#
# Github: https://github.com/Xaycn
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
PLAIN='\033[0m'

#
usage='wget -qO- git.io/goshell | bash'

message() {
    if [ "$1" = 'success' ]; then
        echo -e "[${GREEN}success${PLAIN}] $2"
    elif [ "$1" = 'error' ]; then
        echo -e "[${RED}error${PLAIN}] $2"
    elif [ -n "$1" ] && [ -z "$2" ]; then
        echo -e $1
    else
        echo -e "[${YELLOW}$1${PLAIN}] $2"
    fi
}

intro() {
    echo -e " Usuage : ${GREEN}${usage}${PLAIN}"
    printf "%-70s\n" "=" | sed 's/\s/=/g'
    echo "| Copyright (C) By Xaycn <Xaycn@outlook.com>"
    printf "%-70s\n" "+" | sed 's/\s/-/g'
    echo "| Github: https://github.com/Xaycn"
    printf "%-70s\n" "+" | sed 's/\s/-/g'
    echo "| The powerful script to meet your needs."
    printf "%-70s\n" "+" | sed 's/\s/-/g'
}

menu() {
    echo -e "\n\t\tMENU\n"
    echo -e "\t1. Linux System Basic Test"
    echo -e "\t2. Linux Network Speed Test" 
    echo -e "\t3. Install BBR" 
    echo -e "\t4. Install SS/SSR/V2Ray" 
    echo -e "\t5. Install LAMP/LNMP" 
    echo -e "\t0. Exit \n\n"
    while read -p "Enter option:" option
    do 
        case $option in
        0)
            break
            ;;
        1)
            system_test
            exit
            ;;
        2)
            speed_test
            exit
            ;;
        3)
            install_bbr
            exit
            ;;
        4)
            install_ss
            exit
            ;;
        5)
            install_lamp
            exit
            ;;
        *)
            message error "Please choose your right need."
            ;;
        esac
    done
    clear
}

system_test() {
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/xaycn/shell/master/system | bash
}

speed_test() {
    exit
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/xaycn/shell/master/speed | bash
}

install_bbr() {
    exit
    wget -qO- bbr | bash
}

install_ssr() {
    exit
    wget -qO- ssr | bash
}

clear
intro
menu

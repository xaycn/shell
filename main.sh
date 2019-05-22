#!/usr/bin/env bash
#
# A powerful script to meet your needs.
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
ver='1.0.0'
update_time='2019-5-22'
usage='wget -qO- git.io/superbench.sh | bash'

note() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

is_exec() {
    if type $1 >/dev/null; then 
        return 0
    else
        return 1
    fi
}

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

init() {
    echo -e " Version : ${RED}${ver}${PLAIN} Time : ${GREEN}${update_time}${PLAIN}"
    echo -e " Usuage  : ${YELLOW}${usage}${PLAIN}"
    get_info
}

calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}
    do
        [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
        [ "`echo ${size:(-1)}`" == "K" ] && size=0
        [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
        [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
        [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
        total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
    done
    echo ${total_size}
}

get_info() {
    ip=$( curl -s api.ip.la/en?json )
    ipipv4=$(echo "${ip}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'ip'\042/){print $(i+1)}}}' | tr -d '"' | sed -n 1p)
    ipipv6=$( curl -s ipv6.icanhazip.com )
    ipcity=$(echo "${ip}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'city'\042/){print $(i+1)}}}' | tr -d '"' | sed -n 1p)
    ipcountry=$(echo "${ip}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'country_name'\042/){print $(i+1)}}}' | tr -d '"' | sed -n 1p)
    ipprovince=$(echo "${ip}" | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'province'\042/){print $(i+1)}}}' | tr -d '"' | sed -n 1p)
    iporg=$( curl -s ipinfo.io/org )

    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
    freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    tram=$( free -m | awk '/Mem/ {print $2}' )
    uram=$( free -m | awk '/Mem/ {print $3}' )
    swap=$( free -m | awk '/Swap/ {print $2}' )
    uswap=$( free -m | awk '/Swap/ {print $3}' )
    up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days, %d hour %d min\n",a,b,c)}' /proc/uptime )
    load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    opsy=$( get_opsy )
    arch=$( uname -m )
    lbit=$( getconf LONG_BIT )
    kern=$( uname -r )
    disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|udev|docker' | awk '{print $2}' ))
    disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|udev|docker' | awk '{print $3}' ))
    disk_total_size=$( calc_disk "${disk_size1[@]}" )
    disk_used_size=$( calc_disk "${disk_size2[@]}" )
    tcpctrl=$( sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}' )
    
}

ipinfo() {
    echo -e "IPv4            : ${BLUE}$ipipv4${PLAIN}"
    echo -e "IPv6            : ${BLUE}$ipipv6${PLAIN}"
    echo -e "Organization    : ${BLUE}$iporg${PLAIN}"
    echo -e "Location        : ${BLUE}$ipcountry, ipprovince, ipcity /${PLAIN}"
}

sysinfo() {
    echo -e "CPU model            : ${BLUE}$cname${PLAIN}"
    echo -e "Number of cores      : ${BLUE}$cores${PLAIN}"
    echo -e "CPU frequency        : ${BLUE}$freq MHz${PLAIN}"
    echo -e "CPU Cache            : ${SKYBLUE}$corescache ${PLAIN}"
    echo -e "Total Disk           : ${BLUE}$disk_total_size GB ($disk_used_size GB Used)${PLAIN}"
    echo -e "Total Memory         : ${BLUE}$tram MB ($uram MB Used)${PLAIN}"
    echo -e "Total Swap           : ${BLUE}$swap MB ($uswap MB Used)${PLAIN}"
    echo -e "Load average         : ${BLUE}$load${PLAIN}"
    echo -e "OS                   : ${BLUE}$opsy${PLAIN}"
    echo -e "Arch                 : ${BLUE}$arch ($lbit Bit)${PLAIN}"
    echo -e "Kernel               : ${BLUE}$kern${PLAIN}"
    echo -e "Virt-what            : ${BLUE}$kern${PLAIN}"
    echo -e "System uptime        : ${BLUE}$up${PLAIN}"
}

menu() {
    echo '--'
}

clear
note
init
note
ipinfo
note
sysinfo
note
menu

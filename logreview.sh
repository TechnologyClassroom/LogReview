#!/bin/bash

# LogReview gives a quick overview of recent web server traffic, their IP
# addresses, their user-agents, and the URLs that they visited. LogReview is
# handy for quickly finding what behavior might be slowing down popular web
# servers.
#
# Version 20260116
#
# Copyright (C) 2024-2026 Michael McMahon
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# LogReview source lives at https://github.com/TechnologyClassroom/LogReview

set -euo pipefail
#set -euxo pipefail  # DEBUG

# Variables are set in the logreview.conf file with
# logreview.conf.defaults as defaults.

# LogReview depends on these programs: Bash, grep, echo, head, cut, tail, cat,
# bzcat, zcat, sort, uniq, awk, sed, tee

# Variable load code is from an anonymous SE user.
# https://unix.stackexchange.com/a/331965/553861
config_read_file() {
  (grep -E "^${2}=" -m 1 "${1}" 2>/dev/null || echo "VAR=__UNDEFINED__") \
    | head -n 1 \
    | cut -d '=' -f 2-
}

config_get() {
  val="$(config_read_file logreview.conf "${1}")";
  if [ "${val}" = "__UNDEFINED__" ]; then
    val="$(config_read_file logreview.conf.defaults "${1}")";
  fi
  printf -- "%s" "${val}";
}

logfile="$(config_get logfile)"
#printf -- "%s\n" "$(config_get logfile)"
logfile2="$(config_get logfile2)"
#printf -- "%s\n" "$(config_get logfile2)"
ipcol="$(config_get ipcol)"
#printf -- "%s\n" "$(config_get ipcol)"
logs="$(config_get logs)"
#printf -- "%s\n" "$(config_get logs)"
topipcount="$(config_get topipcount)"
#printf -- "%s\n" "$(config_get topipcount)"
topuacount="$(config_get topuacount)"
#printf -- "%s\n" "$(config_get topuacount)"
topurlcount="$(config_get topurlcount)"
#printf -- "%s\n" "$(config_get topurlcount)"
topuatotalcount="$(config_get topuatotalcount)"
#printf -- "%s\n" "$(config_get topuatotalcount)"
compressiontype="$(config_get compressiontype)"
#printf -- "%s\n" "$(config_get compressiontype)"
logtype="$(config_get logtype)"
#printf -- "%s\n" "$(config_get logtype)"

# Print logs to work on.
# Quick refactor for both 1 and 2 logs.
catlog () {
  if [ $logs -eq 1 ]; then
    cat "$logfile"
  elif [ $logs -eq 2 ]; then
    cat "$logfile" "$logfile2"
  else
    echo "logs must be set to either 1 or 2."
    exit 1
  fi
}

# Print all logs to work on.
catalllog () {
  if [[ $compressiontype =~ "bz" ]]; then
    bzcat -f "${logfile}"*
  elif [[ $compressiontype =~ "gzip" ]]; then
    zcat -f "${logfile}"*
  else
    echo "compressiontype must be set to either bz or gzip."
    exit 1
  fi
}

# These are inclusions to keep from log results.
# This should include the search and anything necessary for parsing the web log.
grepinclusion () {
  if [[ $logtype =~ "syslog" ]]; then
    grep -e "apache\[" -e "apache:" -e "nginx\[" -e "nginx:"
  elif [[ $logtype =~ "apache" ]]; then
    grep "."
  elif [[ $logtype =~ "nginx" ]]; then
    grep "."
  else
    echo "logtype must be set to either apache, nginx, or syslog."
    exit 1
  fi
}

# These are exclusions to drop from log results.
# Some of these are known good.
# Some of these have already been blocked.
grepexclusion () {
  grep -v \
    `# TMPBLOCKS` \
    `# RSS` -e "/blogs/RSS" -e "Yarr/1.0" -e "newsboat/" -e "RssReader" -e "RSS-Parrot-Bot" -e "NetNewsWire" -e "CapyReader" -e "maubot/rss" -e "RSS Guard" -e "FreshRSS" -e "MonitoRSS" -e "gwene.org rss-to-news" -e "SpaceCowboys Android RSS Reader" -e "Tiny Tiny RSS" -e "Akregator" -e "akregator" -e "Mastodon/" -e "Thunderbird/" -e "newspaper/" -e "URL/Emacs Emacs/" -e "Newsboat/" -e "Leaf/48 CFNetwork" -e "App-Feedmailer" \
    `# Attempts at finding GPG/PGP keys.` -e "/.well-known/openpgpkey/" \
    `# Known good automation` -e "Uptime-Kuma/" -e "Blackbox Exporter" \
    `# Search engine Seznam` -e "SeznamBot/4.0" \
    `# Pleroma` -e "Pleroma" \
    `# ArchiveBot` -e "ArchiveBot/" \
    `# tmp202505 kioworker?` -e "kioworker" \
    `# Mozilla` -e "DotBot/1.2" \
    `# Supposedly search engines` -e "SeekportBot" -e "rightdao.com" -e "Heexybot" -e "search.marginalia.nu" \
    `# 202508Google` -e "66.249.64."  -e "66.249.65." -e "66.249.66." -e "66.249.67." -e "66.249.68." -e "66.249.69." -e "66.249.70." -e "66.249.71." -e "66.249.72." -e "66.249.73." -e "66.249.74." -e "66.249.75." -e "66.249.76." -e "66.249.77." -e "66.249.78." -e "66.249.79." -e "66.249.80." -e "66.249.81." -e "66.249.82." \
    `# MSBING` -e "40.77.167." -e "207.46.13." -e "157.55.39." -e "13.66.139." -e "13.66.144." -e "52.167.144." -e "13.67.10." -e "13.69.66." -e "13.71.172." -e "139.217.52." -e "191.233.204." -e "20.36.108." -e "20.43.120." -e "40.79.131." -e "40.79.186." -e "52.231.148." -e "20.79.107." -e "51.105.67." -e "20.125.163." -e "40.77.188." -e "40.77.189."
}

# Count unique lines sorted by number.
sucsn () {
  sort \
  | uniq -c \
  | sort -n
}

# You can throw this into grepinclusion to isolate to a specific hour.
#  | grep "Jan 14 09:" `# Temp` \

echo "Searching through logs. This may take a moment..."
# Find top hitting IPs with exclusions for known entities.
for i in $(catlog \
  | grepinclusion \
  | grepexclusion \
  | awk '{ print '"$ipcol"' }' \
  | sucsn \
  | tail -n "$topipcount" \
  | awk '{ print $2 }'); do

  echo
  # Display hit count and IP address.
  echo "Count of IP address:"
  catlog \
    | grep "$i" \
    | grepinclusion \
    | awk '{ print '"$ipcol"' }' \
    | sucsn \
    | tail -n 1

  # Show top user-agents.
  echo "Top $topuacount user-agents:"
  catlog \
    | grep "$i" \
    | grepinclusion \
    | awk -F'"' '{print $(NF>1?NF-1:"")}' \
    | sucsn \
    | tail -n "$topuacount"

  # Show last requested URLs.
  echo "Last $topurlcount requested URLs:"
  # If the request is unusual, it will be blank.
  catlog \
    | grep "$i" \
    | grepinclusion \
    | awk -F'"' '{print $(NF>5?NF-5:"")}' \
    | sed "s/^(GET|POST|DELETE|PUT|PATCH|HEAD) //g;s| HTTP/.*$||g;/^$/d" \
    | tail -n "$topurlcount"

  # Show top requested URLs.
  echo "Top $topurlcount requested URLs:"
  catlog \
    | grep "$i" \
    | grepinclusion \
    | awk -F'"' '{print $(NF>5?NF-5:"")}' \
    | sed "s/^(GET|POST|DELETE|PUT|PATCH|HEAD) //g;s| HTTP/.*$||g;/^$/d" \
    | sucsn \
    | tail -n "$topurlcount"
done

echo
echo "Top user-agents:"
# Top user-agents
catlog \
  | grepinclusion \
  | grepexclusion \
  | awk -F'"' '{print $(NF>1?NF-1:"")}' \
  | sucsn \
  | tail -n "$topuatotalcount"

echo
echo "Top user-agents with grouped versions:"
# Top user-agents with grouped versions to potentially identify random number
# generators being used on the version value to intentionally stay undetected.
catlog \
  | grepinclusion \
  | grepexclusion \
  | awk -F'"' '{print $(NF>1?NF-1:"")}' \
  | `# Group randomized versions.` sed 's/\/[0-9]*\./\/wildcard\./g' \
  | sucsn \
  | tail -n "$topuatotalcount"

# Disabling because I configure these to give 403 now. 20250404
#echo
#echo "Top no UA:"
#for i in $(catlog \
#  | grepinclusion \
#  | grep -E '"-"$' \
#  | grepexclusion \
#  | awk '{ print '"$ipcol"' }' \
#  | sucsn \
#  | tail -n "$topipcount" \
#  | awk '{ print $2 }'); do
#  echo
#  # Display hit count and IP address.
#  catlog \
#    | grep "$i" \
#    | grepinclusion \
#    | awk '{ print '"$ipcol"' }' \
#    | sucsn \
#    | tail -n 1
#  # Top user-agents
#  catlog \
#    | grep "$i" \
#    | grepinclusion \
#    | awk -F'"' '{print $(NF>1?NF-1:"")}' \
#    | sucsn \
#    | tail -n "$topuacount"
#  # Last requested URLs
#  # If the request is unusual, it will be blank.
#  catlog \
#    | grep "$i" \
#    | grepinclusion \
#    | awk -F'"' '{print $(NF>5?NF-5:"")}' \
#    | sed "s/^(GET|POST|DELETE|PUT|PATCH|HEAD) //g;s| HTTP/.*$||g;/^$/d" \
#    | tail -n "$topurlcount"
#  # Top requested URLs
#  catlog \
#    | grep "$i" \
#    | grepinclusion \
#    | awk -F'"' '{print $(NF>5?NF-5:"")}' \
#    | sed "s/^(GET|POST|DELETE|PUT|PATCH|HEAD) //g;s| HTTP/.*$||g;/^$/d" \
#    | sucsn \
#    | tail -n "$topurlcount"
#done

# Apache Mod Evasive
#if [ -f /etc/apache2/mods-enabled/evasive.conf ]; then
#  echo
#  echo "Top apache2 mod evasive:"
#  for i in $(cat /var/log/syslog \
#    | grep "possible DoS attack" \
#    | sed 's/^.* Blacklisting address //g;s/: possible DoS attack.$//g' \
#    | sucsn \
#    | awk '$1 > 1' \
#    | tail -n "$topipcount" \
#    | awk '{ print '"$ipcol"' }'); do
#    echo
#    # Display hit count and IP address.
#    catlog \
#      | grep "$i" \
#      | grepinclusion \
#      | awk '{ print '"$ipcol"' }' \
#      | sucsn \
#      | tail -n 1
#    # Top user-agents
#    catlog \
#      | grep "$i" \
#      | grepinclusion \
#      | awk -F'"' '{print $(NF>1?NF-1:"")}' \
#      | sucsn \
#      | tail -n "$topuacount"
#    # Last requested URLs
#    # If the request is unusual, it will be blank.
#    catlog \
#      | grep "$i" \
#      | grepinclusion \
#      | awk -F'"' '{print $(NF>5?NF-5:"")}' \
#      | sed "s/^(GET|POST|DELETE|PUT|PATCH|HEAD) //g;s| HTTP/.*$||g;/^$/d" \
#      | tail -n "$topurlcount"
#    # Top requested URLs
#    catlog \
#      | grep "$i" \
#      | grepinclusion \
#      | awk -F'"' '{print $(NF>5?NF-5:"")}' \
#      | sed "s/^(GET|POST|DELETE|PUT|PATCH|HEAD) //g;s| HTTP/.*$||g;/^$/d" \
#      | sucsn \
#      | tail -n "$topurlcount"
#  done
#fi

#echo -e "\nThese addresses look like they are all wordpress abuse:"
##catalllog \
#catlog \
#  | grep -e "wp-includes" -e "xmlrpc.php" -e "wp-admin" \
#  | grepinclusion \
#  | grepexclusion \
#  > /tmp/"$(date +%Y-%m-%d)"-wp-abuse.txt
#awk '{ print $1 }' /tmp/"$(date +%Y-%m-%d)"-wp-abuse.txt \
#  | sort \
#  | uniq
#echo -e "\nThese addresses look like they are all wordpress post abuse:"
##catalllog \
#catlog \
#  | grep "wp-json/wp" \
#  | grepinclusion \
#  | grepexclusion \
#  > /tmp/"$(date +%Y-%m-%d)"-wp-abuse.txt
#awk '{ print $1 }' /tmp/"$(date +%Y-%m-%d)"-wp-abuse.txt \
#  | sort \
#  | uniq

#echo
#echo "Fell into the trap."
##catalllog \
#catlog \
#  | grep "/trap/" \
#  | grepinclusion \
#  | grepexclusion \
#  | sucsn

# fail2ban
if [ -f /var/log/fail2ban.log ]; then
  echo
  echo "Repeat IPs from fail2ban ban logs:"
  zcat -f /var/log/fail2ban.log* \
    | grep " Ban " \
    | sed 's/^.* Ban //g' \
    | sort \
    | uniq -c \
    | sort -n \
    | awk '$1 > 1' \
    | tee /tmp/repeat-fail2ban-offenders-$(date +%Y%m%d).txt
fi

exit 0

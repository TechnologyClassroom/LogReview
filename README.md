# LogReview

`logreview.sh` is a script that is useful for reviewing logs from popular web
servers.

It is still a work-in-progress (WIP), but it is functional enough that it helps
at this point. More complete projects include
[goaccess](https://github.com/allinurl/goaccess/) and
[apachetop](https://github.com/tessus/apachetop), but this is good in some ways
too.

LogReview pairs well with my
[firewallblockgen](https://github.com/TechnologyClassroom/firewallblockgen/)
scripts to identify larger patterns and block addresses in bulk.

LogReview can be found at https://github.com/TechnologyClassroom/LogReview/

## Limits

LogReview helps to quickly find the most obvious problems with a web server.
LogReview may not help when...

* ...botnets and vulnerability scanners intentionally try to "fly under the
  radar" of log analysis by rotating quickly through IPs.
* ...user-agent are intentionally randomized with random number generators. You
  would need to do a more in-depth scan of all user-agents to find this
  pattern.
* ...large files are used to hog bandwidth. apachetop or GoAccess help here.
* ...slowloris attacks are used.

## How to use logreview.sh

You put it on a server.

    git clone https://github.com/TechnologyClassroom/LogReview

Change to the directory.

    cd LogReview

Copy the template configuration file:

    cp logreview.conf.default logreview.conf

Change the config file to match your log.

    editor logreview.conf

Run the script.

    bash logreview.sh

The output should help get a glimpse of what is happening. Potentially block
individual addresses with unwanted behavior or use tools to modify unwanted
behavior.

After taking action or recognizing known behavior, you can add addresses to the
TMPBLOCK line to dig deeper.

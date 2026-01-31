# LogReview

`logreview.sh` is a script that is useful for manually reviewing logs from
popular web servers to quickly find abuse patterns.

For a visual demo of how I use LogReview in context with my other tools,
watch my presentation
[How to fight DDoS attacks from the command line from BSides CT 2025](https://www.youtube.com/watch?v=BREJ58Y2Ez0)
for a more complete picture of the process I use to thwart attacks.

It is still a work-in-progress (WIP), but it is functional enough that it helps
at this point. More complete projects include
[goaccess](https://github.com/allinurl/goaccess/) and
[apachetop](https://github.com/tessus/apachetop), but this is good in some ways
too.

LogReview pairs well with my
[firewallblockgen](https://github.com/TechnologyClassroom/firewallblockgen/)
scripts to identify larger patterns and block addresses in bulk. For
automated handling, I recommend using the configuration I submitted as a PR for
[reaction with ipset](https://reaction.ppom.me/actions/ipset.html) instead of
fail2ban.

LogReview can be found at https://github.com/TechnologyClassroom/LogReview/

## Limits

LogReview helps to quickly find the most obvious problems with a web server.
LogReview may not help when...

* ...botnets and vulnerability scanners intentionally try to "fly under the
  radar" of log analysis by rotating quickly through IPs. The top user-agent
  results in logreview.sh may still identify patterns here.
* ...user-agent are intentionally randomized. A more thorough review of all
  user-agents may help discover further patterns.
* ...large files are used to hog bandwidth. apachetop or GoAccess help here.
* ...slowloris attacks are used.

## How to use logreview.sh

Place the LogReview on a server.

    git clone https://github.com/TechnologyClassroom/LogReview logreview

Change to the directory.

    cd logreview

Copy the template configuration file:

    cp logreview.conf.defaults logreview.conf

Change the config file to match your log. The config needs to point to the web
server log file and specify which column the IPs are located.

    editor logreview.conf

Run the script.

    bash logreview.sh

The output should help get a glimpse of what is happening. Potentially block
individual addresses with unwanted behavior or use tools to modify unwanted
behavior.

After taking action or recognizing known behavior, you can add addresses to the
`TMPBLOCK` line to continue digging deeper.

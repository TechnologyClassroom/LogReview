# LogReview

`logreview.sh` is a script that is useful for manually reviewing logs from
popular web servers to quickly find abuse patterns. Use
[Occam's razor](https://en.wikipedia.org/wiki/Occam%27s_razor) first to find
the most likely troublemakers.

For a visual demo of how I use LogReview in context with my other tools,
watch my BSides CT 2025 presentation
[How to fight DDoS attacks from the command line](https://www.youtube.com/watch?v=BREJ58Y2Ez0)
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
  user-agents may help discover further patterns of abnormalities.
* ...large files are used to hog bandwidth. apachetop or GoAccess help here.
* ...slowloris attacks are used.

## How to use logreview.sh

Place LogReview on a server the first time you are configuring LogReview.

    git clone https://github.com/TechnologyClassroom/LogReview logreview

Change to the directory.

    cd logreview

Copy the template configuration file the first time you are configuring
LogReview.

    cp -n logreview.conf.defaults logreview.conf

Change the config file to match your log the first time you are configuring
LogReview. The config needs to point to the web server log file and specify
which column the IPs are located.

    editor logreview.conf

Run the script.

    bash logreview.sh

The output should help get a glimpse of what is happening. Potentially block
individual addresses with unwanted behavior or use tools to modify unwanted
behavior.

Make sure you do not take action against automation that you are running on
your own site like the site monitoring processes that you may be running
yourself such as [Uptime Kuma](https://uptime.kuma.pet/),
[Prometheus](https://prometheus.io/), or [Munin](http://munin-monitoring.org/).
Place these addresses and or user-agents under the `grepexclusion` section of
`logreview.sh` to exclude known good results.

After taking action or recognizing known behavior, you can add addresses to the
`TMPBLOCK` line to continue digging deeper.

## Patterns to look for

- The top 10 most frequent IP addresses hitting the server likely show what is
  slowing the server down.

- If an IP address or user-agent is hitting your site at several
  [orders of magnitude](https://en.wikipedia.org/wiki/Order_of_magnitude)
  greater than anything else. Look at it first. If it claims to be a normal web
  browser user-agent, it is likely lying.

- Bots that identify themselves
  - Bots run by search engines are typically wanted by most sites. Blocking
    them will affect your page rank or Seach Engine Optimization (SEO). I would
    recommend not doing this for known good search engines such as Googlebot,
    Applebot, bingbot, DuckDuckBot, SeznamBot, YandexBot, MojeekBot, Amazonbot,
    yacybot, and Yahoo! Slurp unless they are specifically broken.
    - There are exception though. Sometimes bots will identify as a search
      engine bot while not really having a functional search engine. This is
      one tactic used by companies building datasets for training generative
      AI models.
  - Common Crawl (CCBot) is an attempt at crawling the entire web collectively
    so that every single company crawling the web could stop and just download
    the latest Common Crawl archive. Having one bot hit your site would be
    better than having dozens hit your site right? Reality is a bit different,
    but the concept is nice. I allow it.

- If a specific version of a web browser is the top user-agent by a significant
  margin and it is about 10 or more versions behind what you would expect, it
  is likely some time of automation. Acquire the list of IPs used by that
  user-agent on your server and process them with my
  [ip-to-asn-info.sh](https://github.com/TechnologyClassroom/firewallblockgen/blob/main/ip-to-asn-info.sh)
  script from
  [FirewallBlockGen](https://github.com/TechnologyClassroom/firewallblockgen/)
  to find out more about where the requests are coming from. You will likely
  find that it is a bot that does not identify itself.


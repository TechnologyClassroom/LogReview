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

LogReview lives in the <https://github.com/TechnologyClassroom/LogReview/>
repository.

## Limits

LogReview helps to quickly find the most obvious problems with a web server.
LogReview may not help when...

* ...botnets and vulnerability scanners intentionally try to "fly under the
  radar" of log analysis by rotating quickly through IPs. The top user-agent
  results in logreview.sh may still identify patterns here.
* ...user-agent are intentionally randomized. A more thorough review of all
  user-agents may help discover further patterns of abnormalities. The top
  user-agent with wildcard results in logreview.sh may still identify
  patterns here.
* ...large files are used to hog bandwidth. apachetop or GoAccess help here.
* ...one is looking for a general metrics and analytics solution.
* ...slowloris attacks are used.

## How to use logreview.sh

### Installation, configuration, and run

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

If you do not have any logs, you can use simulated data I made in the
[web-server-mock-data](https://github.com/TechnologyClassroom/web-server-mock-data)
repository.

    git submodule update --init --recursive
    cp -n logreview.conf.test logreview.conf

Run the script.

    bash logreview.sh

The output should help get a glimpse of what is happening. Potentially block
individual addresses with unwanted behavior or use tools to modify unwanted
behavior.

### Reading the output

Here is an example of the output of LogReview redacted from a real run. The IP
addresses and requests have been redacted, but the user-agents and quantities
are real.

```
Mon Apr  6 11:05:49 EDT 2026

Searching through logs. This may take a moment...

Count of IP address:
   5995 192.168.2.188
Top 3 user-agents:
   1159 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1360 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1414 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
     18 GET /redacted/index.html
     18 GET /redacted/index.html
   1308 GET /redacted/index.html

Count of IP address:
   6076 192.168.2.134
Top 3 user-agents:
   1211 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1268 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1354 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
     18 GET /redacted/index.html
     18 GET /redacted/index.html
   1471 GET /redacted/index.html

Count of IP address:
   6130 192.168.2.8
Top 3 user-agents:
   1333 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1385 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1424 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
     18 GET /redacted/index.html
     18 GET /redacted/index.html
   1355 GET /redacted/index.html

Count of IP address:
   6229 192.168.50.4
Top 3 user-agents:
    630 amazon-Quick-on-behalf-of-664570f1
    707 amazon-Quick-on-behalf-of-950399e0
   1013 amazon-Quick-on-behalf-of-de796e21
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
    793 GET /redacted/index.html
    795 GET /redacted/index.html
    799 GET /redacted/index.html

Count of IP address:
   6927 192.168.2.52
Top 3 user-agents:
   1350 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1623 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1666 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
     18 GET /redacted/index.html
     18 GET /redacted/index.html
   1556 GET /redacted/index.html

Count of IP address:
   7180 192.168.50.2
Top 3 user-agents:
    494 amazon-Quick-on-behalf-of-c25aa9c3
    871 amazon-Quick-on-behalf-of-28836b69
   1417 amazon-Quick-on-behalf-of-34f4923b
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
    803 GET /redacted/index.html
    813 GET /redacted/index.html
    813 GET /redacted/index.html

Count of IP address:
   7340 192.168.2.39
Top 3 user-agents:
   1557 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1618 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   1648 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
     18 GET /redacted/index.html
     18 GET /redacted/index.html
   1425 GET /redacted/index.html

Count of IP address:
   9858 192.168.2.18
Top 3 user-agents:
   2186 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   2196 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   2289 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
     18 GET /redacted/index.html
     24 GET /redacted/index.html
   2270 GET /redacted/index.html

Count of IP address:
  10171  192.168.2.7
Top 3 user-agents:
   2238 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   2243 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
   2435 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Last 3 requested URLs:
GET /redacted/index.html
GET /redacted/index.html
GET /redacted/index.html
Top 3 requested URLs:
      4 GET /redacted/index.html
      6 GET /redacted/index.html
   2699 GET /redacted/index.html

Count of IP address:
  51640 192.168.1.12
Top 3 user-agents:
   1078 Mozilla/5.0 (Macintosh; Intel Mac OS X 11_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.5304.62 Safari/537.36
   1080 Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.5563.111 Safari/537.36
   1080 Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 Edg/107.0.1418.24
Last 3 requested URLs:
HEAD /0404.zip
HEAD /0405.zip
HEAD /0406.zip
Top 3 requested URLs:
      2 HEAD /www_202604.rar
      2 HEAD /www_202604.tar.gz
      2 HEAD /www_202604.zip

Top user-agents:
  38599 Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0
  44923 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36
  45215 Mozilla/5.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/149.0
  47368 Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
  49665 Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36
  50243 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
  50707 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
  58599 Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.5359.95 Safari/537.36 QIHU 360SE
  97038 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36

Top user-agents with grouped versions:
  38650 Mozilla/wildcard.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/wildcard.0
  44930 Mozilla/wildcard.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.3497.100 Safari/wildcard.36
  45256 Mozilla/wildcard.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/wildcard.0
  52433 Mozilla/wildcard.0 (Windows NT 10.0; Win64; x64) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.0.0 Safari/wildcard.36 Edg/wildcard.0.0.0
  58599 Mozilla/wildcard.0 (Windows NT 10.0; WOW64) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.5359.95 Safari/wildcard.36 QIHU 360SE
  66213 Mozilla/wildcard.0 (Linux; Android 10; K) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.0.0 Mobile Safari/wildcard.36
 102926 Mozilla/wildcard.0 (X11; Linux x86_64) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.0.0 Safari/wildcard.36
 173996 Mozilla/wildcard.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.0.0 Safari/wildcard.36
 274309 Mozilla/wildcard.0 (Windows NT 10.0; Win64; x64) AppleWebKit/wildcard.36 (KHTML, like Gecko) Chrome/wildcard.0.0.0 Safari/wildcard.36
```

Starting with the last entry `192.168.1.12` is a vulnerability scanner of some
sort scanning for archives that are not linked from the site. The address can
and should be blocked. This is not the problem with the site though because
these are light `HEAD` requests. If you find any file extensions from scanners
like that that you never use, you can add them to your `fail2ban` or `reaction`
configuration. For example, if a scan searches for `.rar` files and you only
use `.zip` and `.tar.gz` archives, you can ban addresses that try to download
`.rar` files. I left the requests for only this entry mostly unredacted, but I
did leave out some identifying information that would reveal the domain.

The 2nd, 3rd, 4th, 6th, 8th, 9th, 10th most frequent IPs all follow the same
crawler pattern. This is the problem the server faced and must be stopped
through automation. `Chrome/120.0.0.0` was released in late 2023 and at the
time of this writing in 2026 is about 2 and a half years old. On Windows and
macOS systems, Chrome is kept automatically updated to the latest release so
that is suspicious. The same addresses use equal parts Windows, macOS, and
Linux which is suspicious. The same activity is coming from multiple IP
addresses which is suspicious. You can go a step further by finding all of the
IPs that match this pattern on your server and process them with my
[ip-to-asn-info.sh](https://github.com/TechnologyClassroom/firewallblockgen/blob/main/ip-to-asn-info.sh)
script from
[FirewallBlockGen](https://github.com/TechnologyClassroom/firewallblockgen/) to
find out more about where the requests are coming from.

The 5th and 7th most frequent IPs is allegedly Amazon Quick. I would suggest
adding a filter in the web server configuration to return a 403 when the
user-agent matches the `^amazon-Quick-on-behalf-of-.*$` pattern.

Looking at the `Top user-agents:` and `Top user-agents with grouped versions:`
sections is not all that interesting with this example, but it can be. These
two lines do stand out though:

```
  44923 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36
  58599 Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.5359.95 Safari/537.36 QIHU 360SE
```

`Chrome/69.0.3497.100` was released in late 2018 and at the time of this
writing in 2026 is about 8 years old. `Chrome/108.0.5359.95` was released in
late 2022 and at the time of this writing in 2026 is about 3 and a half years
old. On Windows and macOS systems, Chrome is kept automatically updated to the
latest release so these are very suspicious.
[imperva's 2025 Bad Bot Report](https://www.imperva.com/resources/wp-content/uploads/sites/6/reports/2025-Bad-Bot-Report.pdf)
on page 34 recomends blocking user-agents of browsers that have been
end-of-life for more than three years and giving a CAPTCHA to user-agents of
browsers that have been end-of-life for more than two years.

Make sure you do not take action against automation that you are running on
your own site like the site monitoring processes that you may be running
yourself such as [Uptime Kuma](https://uptime.kuma.pet/),
[Prometheus](https://prometheus.io/), or [Munin](http://munin-monitoring.org/).
Place these addresses and or user-agents under the `grepexclusion` section of
`logreview.sh` to exclude known good results.

I would recommend taking notes on the research that you find. You will likely
see patterns over time and you may forget the decisions that you previously
made. Sometimes your decisions may change over time based on new information
that is contrary to how a service presents itself.

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
    - Sometimes I have seen bad bots impersonating one of the major search
      engines by using their exact same user-agents so I would recommend
      avoiding the exclusion of their user-agents from results. Many of the
      major search engines provide documentation of verifying the authenticity
      of their bots.
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

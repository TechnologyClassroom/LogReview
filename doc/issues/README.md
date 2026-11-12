# Issues

When I have a brief moment to work on one of my personal repositories,
sometimes I am just on the command line and I do not have all of my passwords,
API keys, and credentials. GitHub is now often behind authentication likely due
to the same abuse from big tech that I am seeing so I might not have the notes
from my Issue Tracker handy.

This directory is a backup of my issue tracker and comments. This may not be
the most accurate, up-to-date copy.

## How was this directory created?

Manually syncing these issues would be a waste of time.

### gh2md

[gh2md](https://github.com/mattduck/gh2md) is a python script that can download
GitHub issues. This works for downloading issues as of 2026-09-30.

#### Installing gh2md

On a Debian system, you can install `pipx` with these commands:

    sudo apt update
    sudo apt install pipx

Install `gh2md` with pipx using this command:

    pipx install gh2md

#### Creating a GitHub access token

* [Login](https://github.com/login) to [GitHub](https://github.com/).
* Click on your profile icon in the top-right and select the
  [Settings](https://github.com/settings/profile) option.
* Click on the [Credentials](https://github.com/settings/credentials) option.
* Click on the [Fine-grained personal access tokens](https://github.com/settings/personal-access-tokens) option.
* Click on the [Generate new token](https://github.com/settings/personal-access-tokens/new) button and enter your password again.
* Fill in the text box for `Token name`.
* Set an Expiration with the drop-down choices.
* Click on the `Add permissions` button and select the `Issue Fields` option.
* Click on the `Add permissions` button and select the `Issue Types` option.
* Click on the `Generate token` button.
* Copy the token to your password manager.
* Add the token to the `~/.config/gh2md/token` file.

#### Pulling issues with gh2md

You can pull all open issues for repositories with these commands:

    gh2md technologyclassroom/firewallblockgen firewallblockgen/doc/issues --multiple-files --no-prs --no-closed-issues
    gh2md technologyclassroom/logreview logreview/doc/issues --multiple-files --no-prs --no-closed-issues
    gh2md technologyclassroom/webserverwatcher webserverwatcher/doc/issues --multiple-files --no-prs --no-closed-issues

### Removing the img tag

The issues include images which is nice if browsed by a markdown viewer
connected to the Internet, but this is not helpful and extra noise for me in
this case.

#### strip_tags

See the sed section.

[strip_tags](https://github.com/Open-Technology-Foundation/strip_tags) is a set
of scripts that can remove HTML tags from a file.

#### Installing strip_tags

There are Python, Bash, and C versions of this script. For this simple job, the
BASH version that depends on sed is more than we need.

Download the script.

    wget https://github.com/Open-Technology-Foundation/strip_tags/raw/refs/heads/main/strip_tags.bash

Make sure it is what it says it is. Press `q` when you are done.

    less strip_tags.bash

Place the script in a place that is in your path.

    mv strip_tags.bash ~/.local/bin/strip_tags

Make the script executable.

    chmod +x ~/.local/bin/strip_tags

#### Stripping tags with strip_tags

Change to the issues directory.

    cd doc/issues

Run a simple for loop with an intermediary file.

    for i in $(ls 20*md); do echo $i && strip_tags "$i" > "$i"2 && mv "$i"2 "$i" ; done

#### sed

Initially, I expected more complexity and I looked into strip_tags, but this
job is really simple. `sed` is enough. I am keeping the strip_tags
documentation in case I need something more thorough in the future.

Change to the issues directory.

    cd doc/issues

Run a simple for loop to remove the image tag.

    for i in $(ls 20*md); do echo "$i" && sed -i 's/<img.*>//' "$i" ; done

Work-in-progress sed command to clean up the issues.

    sed -E 's/^\[//g;s/\]$//g;s/\[([^]]+)\]\(([^)]+)\)/\1/g;s/Issue \d96op/\d96op/g;s/\# \\\#/\# Issue /g' issuefilename

Sed explanations.

`s/^\[//g;s/\]$//g` removes the leading and trailing brackets found in the last line.

`s/\[([^]]+)\]\(([^)]+)\)/\1/g` removes the markdown links.

`s/Issue \d96op/\d96op/g;s/\# \\\#/\# Issue /g` replaces "# \#1 Issue `open`" with "# Issue 1 `open`"

This is a simple for loop with a complex chain of sed commands to reformat the
issues. I struggled a bit to make this work in-place so I made an intermediary
file.

    for i in $(ls 20*md); do echo $i && sed -E 's/^\[//g;s/\]$//g;s/\[([^]]+)\]\(([^)]+)\)/\1/g;s/Issue \d96op/\d96op/g;s/\# \\\#/\# Issue /g' "$i" > "$i"2 && mv "$i"2 "$i"; done

# cs260a-env

CS260A students - this repo contains code to spin up a docker container with `cron` installed since hills does not allow us to run `crontab`.

## How do I use this?

The easy way is to use `make`. By default, I've configured this to list each command with a description.

### Does this work everywhere?

Nope. It requires unix, as this is dealing with Linux containers. Most of the `make` targets work in both macOS and Linux, except for the bootstrapper (the `prereqs` target); this was only written for macOS. I figure, if you're already running Linux, you know what to do so I'm not going to spend time making the script portable.

### Usage

```bash
# prints a help message detailing the various commands (i.e., "targets") you can run
make

# on macOS, you should only need to run this once ever
# it installs colima (a free docker engine) and the `docker` command line client
make prereqs

# build the image; this only needs to be run once, usually. it may take a few minutes
make image

# start the container
make start

# optional: show that the container is actually running; no output after the headers
#           are printed means that it is NOT running
make ps

# this is how you tear down the container; do this after you've completed your work
make stop

# create an interactive shell session on the container - think of this as like
# ssh-ing into the container (it's not really, but imagine it that way for now)
#
# and yes, you can run this multiple times to get multiple concurrent sessions;
# it's just like logging in multiple times over ssh. Here, you can hack and do
# your classwork.
make shell
```

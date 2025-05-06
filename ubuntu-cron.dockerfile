FROM ubuntu:24.04

ARG REGUSER

RUN apt-get update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y cron vim sudo \
  && apt-get clean \
  && touch /var/log/cron.log \
  # add the user before adding the group so that the UID an GID are the same. 
  # what can I say, I'm anal.
  && useradd -m ${REGUSER} \
  && groupadd admin \
  && usermod -a -G admin ${REGUSER} \
  && echo '%admin ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/admins

WORKDIR /home/${REGUSER}

CMD ["/sbin/cron", "-f"]

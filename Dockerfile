# Docker file to run the latest recommended version of Pluggable Transport
# to help censored users.

FROM debian:stretch
MAINTAINER Nima Fatemi <mrphs@riseup.net>

# make sure the system is up to date
RUN apt-get update && apt-get upgrade -y

# Install tor, obfs4 package
# Install libcap2-bin to be able to assign port 80 to obfs4

RUN apt-get update && apt-get install -y \
        tor \
        obfs4proxy \
        libcap2-bin \
        --no-install-recommends

# Let obfs4proxy use a lower <1024 port number (80)
RUN setcap 'cap_net_bind_service=+ep' /usr/bin/obfs4proxy

# Pick a nice name for your bridge
ENV BRIDGE_NAME enterbridgenamehere

# You need to enter an email add in case someone wants to reach out to you
# Not mandatory but highly recommended
ENV CONTACT_INFO your@email.address

# Pick an ORPort
ENV ORPORT 1984

# open ORPort to the world. mainly for birdgeauth to get the running flag
# ideally, we'll shut this port in future
# see https://trac.torproject.org/projects/tor/ticket/7349

EXPOSE ${ORPORT}

# Open obfs port to the world.
# obfs4 will listen to this port for incoming connections

ENV OBFS_PORT 80
EXPOSE ${OBFS_PORT}

# Backup the original torrc file
RUN mv /etc/tor/torrc /etc/tor/torrc.orig

# Make a new torrc file for our new shiny bridge

RUN printf \
        "RunAsDaemon 1 \
        \nORPort ${ORPORT} \
        \nNickname ${BRIDGE_NAME} \
        \nContactInfo ${CONTACT_INFO} \
        \nExitPolicy reject *:* # no exits allowed \
        \n\nBridgeRelay 1 \
        \nPublishServerDescriptor 1 \
        \nServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy \
        \nServerTransportListenAddr obfs4 0.0.0.0:${OBFS_PORT} \
        \nExtORPort auto" >> /etc/tor/torrc

# Restart Tor
RUN service tor restart

#TODO: add automatic-updates

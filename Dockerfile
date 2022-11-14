# This dockerfile allows to run an crawl inside a docker container

# Pull base image.
FROM debian:10.6

# Install required packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install sudo build-essential autoconf git zip unzip xz-utils apt-utils psmisc automake vim
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install libtool libevent-dev libssl-dev zlib1g  zlib1g-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install net-tools ethtool tshark libpcap-dev iw tcpdump  
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install wget
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# add host user to container
RUN adduser --system --group --disabled-password --gecos '' --shell /bin/bash docker


#download tor
ARG TOR_VERSION=0.4.7.11
RUN wget https://dist.torproject.org/tor-$TOR_VERSION.tar.gz
RUN tar -zxf tor-$TOR_VERSION.tar.gz 
WORKDIR /tor-$TOR_VERSION
RUN ./configure --disable-asciidoc && make && make install	

WORKDIR /
RUN rm -r /tor-$TOR_VERSION
# RUN rm -r /dockersetup-server
# RUN mv /dockersetup-server /home/docker/
# RUN chmod a+x /home/docker/dockersetup-server/Entrypoint.sh

# Set the display
ENV DISPLAY $DISPLAY

EXPOSE 35000


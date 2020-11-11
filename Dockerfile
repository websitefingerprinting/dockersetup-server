# This dockerfile allows to run an crawl inside a docker container

# Pull base image.
FROM debian:10.6

# Install required packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install sudo build-essential autoconf git zip unzip xz-utils apt-utils psmisc automake vim
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install libtool libevent-dev libssl-dev zlib1g  zlib1g-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install net-tools ethtool tshark libpcap-dev iw tcpdump
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
    
# add host user to container
RUN adduser --system --group --disabled-password --gecos '' --shell /bin/bash docker


#download tor
RUN git clone https://github.com/websitefingerprinting/dockersetup-server.git 
RUN tar -zxvf /dockersetup-server/tor-0.4.4.5.tar.gz 
WORKDIR ./tor-0.4.4.5
RUN ./configure --disable-asciidoc && sudo make && sudo make install	

WORKDIR /
RUN rm -r ./tor-0.4.4.5
RUN rm -r /dockersetup-server
# RUN mv /dockersetup-server /home/docker/
# RUN chmod a+x /home/docker/dockersetup-server/Entrypoint.sh

# Set the display
ENV DISPLAY $DISPLAY

EXPOSE 35000



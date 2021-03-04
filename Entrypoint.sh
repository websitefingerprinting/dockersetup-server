#!/bin/bash

# configures and runs a crawl (inside a docker container)
# IMPORTANT: If this file is changed, docker container needs to be rebuilt
DEVICE=eth0
BASE='/home/docker'
TORRC_PATH='/home/docker/tunnel-proxy-linux-docker'
PT='wfdef'
WFD='randomwt'
# set offloads
ifconfig ${DEVICE} mtu 1500
ethtool -K ${DEVICE} tx off rx off tso off gso off gro off lro off


# cp PT repository to container's own space.
cp -r /home/docker/${PT} /home/
pushd $home/{PT}
go build -o obfs4proxy/obfs4proxy ./obfs4proxy

pushd ${BASE}

#set torrc file
# echo 'BandwidthRate 100 KBytes' >>  ${TORRC_PATH}
# echo 'BandwidthBurst 100 KBytes' >>  ${TORRC_PATH}

echo 'DataDirectory /home/docker/tor-config/tunnel-proxy-hostport'$1 >> ${TORRC_PATH}
echo 'Log notice stdout' >>  ${TORRC_PATH}
echo 'SOCKSPort auto' >>  ${TORRC_PATH}
echo 'AssumeReachable 1' >>  ${TORRC_PATH}
echo 'PublishServerDescriptor 0' >>  ${TORRC_PATH}
echo 'Exitpolicy reject *:*' >>  ${TORRC_PATH}
echo 'ORPort auto' >>  ${TORRC_PATH}
echo 'ExtORPort auto' >>  ${TORRC_PATH}
echo 'Nickname '${PT}''${WFD}'' >>  ${TORRC_PATH}
echo 'BridgeRelay 1' >>  ${TORRC_PATH}
echo 'ServerTransportPlugin '${WFD}' exec /home/docker/'${PT}'/obfs4proxy/obfs4proxy' >>  ${TORRC_PATH}
echo 'ServerTransportOptions '${WFD}' '$2'' >>  ${TORRC_PATH}
echo 'ServerTransportListenAddr '${WFD}' 0.0.0.0:35000' >>  ${TORRC_PATH}
# echo 'ServerTransportPlugin obfs4 exec /home/docker/'${PT}'/obfs4proxy/obfs4proxy' >>  ${TORRC_PATH}
# echo 'ServerTransportPlugin obfs4 exec /home/docker/trafficSniffer/obfs4proxy/obfs4proxy' >> ${TORRC_PATH} 



tor -f ${TORRC_PATH}

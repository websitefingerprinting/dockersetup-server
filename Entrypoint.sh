#!/bin/bash

# configures and runs a crawl (inside a docker container)
# IMPORTANT: If this file is changed, docker container needs to be rebuilt
DEVICE=eth0
BASE='/home/docker'
TORRC_PATH='/home/docker/tunnel-proxy-linux-docker'
PT='wfdef'
wfd=$1
port=$2
param=$3
# echo ${wfd}
# echo ${port}
# echo ${param}
# exit 0
# set offloads
# ifconfig ${DEVICE} mtu 1500
# ethtool -K ${DEVICE} tx off rx off tso off gso off gro off lro off

# # set go path
# export PATH=$PATH:/usr/local/go/bin


# cp PT repository to container's own space.
cp -r /home/docker/${PT} /home/

pushd ${BASE}

#set torrc file
# echo 'BandwidthRate 100 KBytes' >>  ${TORRC_PATH}
# echo 'BandwidthBurst 100 KBytes' >>  ${TORRC_PATH}

echo 'DataDirectory /home/docker/tor-config/tunnel-proxy-hostport'${port} >> ${TORRC_PATH}
echo 'Log notice stdout' >>  ${TORRC_PATH}
echo 'SOCKSPort auto' >>  ${TORRC_PATH}
echo 'AssumeReachable 1' >>  ${TORRC_PATH}
echo 'PublishServerDescriptor 0' >>  ${TORRC_PATH}
echo 'Exitpolicy reject *:*' >>  ${TORRC_PATH}
echo 'ORPort auto' >>  ${TORRC_PATH}
echo 'ExtORPort auto' >>  ${TORRC_PATH}
echo 'Nickname '${PT}''${wfd}'' >>  ${TORRC_PATH}
echo 'BridgeRelay 1' >>  ${TORRC_PATH}
echo 'ServerTransportPlugin '${wfd}' exec /home/'${PT}'/obfs4proxy/obfs4proxy' >>  ${TORRC_PATH}
echo 'ServerTransportListenAddr '${wfd}' 0.0.0.0:35000' >>  ${TORRC_PATH}
if [ "${wfd}" != "null" ]; then
	echo 'ServerTransportOptions '${wfd}' '${param}'' >>  ${TORRC_PATH}
fi
# echo 'ServerTransportPlugin obfs4 exec /home/docker/'${PT}'/obfs4proxy/obfs4proxy' >>  ${TORRC_PATH}
# echo 'ServerTransportPlugin obfs4 exec /home/docker/trafficSniffer/obfs4proxy/obfs4proxy' >> ${TORRC_PATH} 



tor -f ${TORRC_PATH}

#!/bin/bash

DEVICE=eth0
BASE='/home/docker'
TORRC_PATH='/home/docker/tunnel-proxy-linux-docker'
EMAIL='jgongac@cse.ust.hk'
PT='wfdef'
wfd=$1
port=$2
param=$3



# cp PT repository to container's own space.
cp -r /home/docker/${PT} /home/

pushd ${BASE}

#set torrc file
# echo 'BandwidthRate 100 KBytes' >>  ${TORRC_PATH}
# echo 'BandwidthBurst 100 KBytes' >>  ${TORRC_PATH}

echo 'ContactInfo '${EMAIL} >> ${TORRC_PATH}
echo 'DataDirectory /home/docker/tor-config/tunnel-proxy-hostport'${port} >> ${TORRC_PATH}
echo 'Log notice stdout' >>  ${TORRC_PATH}
echo 'SOCKSPort auto' >>  ${TORRC_PATH}
echo 'AssumeReachable 1' >>  ${TORRC_PATH}
echo 'PublishServerDescriptor bridge' >>  ${TORRC_PATH}
echo 'Exitpolicy reject *:*' >>  ${TORRC_PATH}
echo 'ORPort auto IPv6Only' >>  ${TORRC_PATH}
echo 'ExtORPort auto' >>  ${TORRC_PATH}
echo 'Nickname '${PT}''${wfd}'' >>  ${TORRC_PATH}
echo 'BridgeRelay 1' >>  ${TORRC_PATH}
echo 'ServerTransportPlugin '${wfd}' exec /home/'${PT}'/obfs4proxy/obfs4proxy' >>  ${TORRC_PATH}
echo 'ServerTransportListenAddr '${wfd}' 0.0.0.0:35000' >>  ${TORRC_PATH}
if [ "${wfd}" != "null" ]; then
	echo 'ServerTransportOptions '${wfd}' '${param}'' >>  ${TORRC_PATH}
fi


tor -f ${TORRC_PATH}

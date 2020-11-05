#!/bin/bash

# configures and runs a crawl (inside a docker container)
# IMPORTANT: If this file is changed, docker container needs to be rebuilt
DEVICE=eth0
BASE='/home/docker'
TORRC_PATH='/home/docker/tor-config/tunnel-proxy-linux-docker'
# set offloads
ifconfig ${DEVICE} mtu 1500
ethtool -K ${DEVICE} tx off rx off tso off gso off gro off lro off
pushd ${BASE}
tor -f ${TORRC_PATH}

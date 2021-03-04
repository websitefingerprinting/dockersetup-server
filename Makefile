# all: build test stop

# this is to forward X apps to host:
# See: http://stackoverflow.com/a/25280523/1336939
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

# paths
BASE_PATH=/home/docker
GUEST_SSH=/home/docker/.ssh
DOCKERSETUP_PATH=/home/docker/dockersetup-server
TORCONFIG_PATH=/home/docker/tor-config

HOST_TORCONFIG_PATH=/home/jgongac/tor-config
HOST_SSH=${HOME}/.ssh
HOST=${HOME}

ENV_VARS = \
	--env="XAUTHORITY=${XAUTH}"					\

VOLUMES = \
	--volume=${HOST_SSH}:${GUEST_SSH}			                    \
	--volume=${HOST}/gan-tunnel:${BASE_PATH}/gan-tunnel             \
	--volume=${HOST}/trafficSniffer:${BASE_PATH}/trafficSniffer     \
	--volume=${HOST}/AlexaCrawler:${BASE_PATH}/AlexaCrawler	        \
    --volume=${HOST}/front:${BASE_PATH}/front                       \
	--volume=${HOST}/tamaraw:${BASE_PATH}/tamaraw                   \
	--volume=${HOST}/dpburst:${BASE_PATH}/dpburst                   \
	--volume=${HOST}/wfdef:${BASE_PATH}/wfdef                       \
	--volume=${HOST_TORCONFIG_PATH}:${TORCONFIG_PATH}               \
	--volume=`pwd`:${DOCKERSETUP_PATH}



port=35000
# pt parameters here
params="n-client-real=1 n-server-real=1 n-client-fake=1 n-server-fake=1 p-fake=0"
# Make routines
build:
	@docker build -t torbridge --rm .

run:
	@docker run -it --rm --name p${port} ${ENV_VARS} ${VOLUMES}  -p ${port}:35000 \
	--privileged torbridge ${DOCKERSETUP_PATH}/Entrypoint.sh "$(port)" $(params)
shell:
	@docker run -it --rm --name p${port} ${ENV_VARS} ${VOLUMES} -p ${port}:35000 \
	--privileged torbridge /bin/bash
clean:
	@sudo rm -rf ${HOST_TORCONFIG_PATH}/tunnel-proxy-hostport*/pt_state/obfs4proxy.log
stop:
	@docker stop `docker ps -a -q -f ancestor=torbridge`
	@docker rm `docker ps -a -q -f ancestor=torbridge`

destroy:
	@docker rmi -f torbridge

reset: stop destroy
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
	--volume=${HOST}/AlexaCrawler:${BASE_PATH}/AlexaCrawler	        \
	--volume=${HOST}/wfdef:${BASE_PATH}/wfdef                       \
	--volume=${HOST_TORCONFIG_PATH}:${TORCONFIG_PATH}               \
	--volume=`pwd`:${DOCKERSETUP_PATH}



port=443

# pt parameters here
## null
# wfd=null
# params=""
## wfgan
# wfd=wfgan
# params=tol=0.4
## tamaraw
# wfd=tamaraw
# params=rho-client=14  rho-server=4 nseg=100
# wfd=tamaraw
# params=rho-client=24 rho-server=8 nseg=200
## front
# wfd=front
# params=w-min=1 w-max=14 n-client=6000 n-server=6000

## regulator
wfd=regulator
params=r=277 d=.94 t=3.55 n=3550 u=3.95 c=1.77


## randomwt
# wfd=randomwt
# params=n-client-real=0 n-server-real=0 n-client-fake=0 n-server-fake=0 p-fake=0
# wfd=randomwt
# params=n-client-real=4 n-server-real=45 n-client-fake=8 n-server-fake=90 p-fake=0.4


# Make routines
build:
	@docker build -t torbridge --rm .

run:
	@docker run -it --rm --name p${port} ${ENV_VARS} ${VOLUMES}  -p ${port}:35000 \
	--privileged torbridge ${DOCKERSETUP_PATH}/Entrypoint.sh "$(wfd)" "$(port)" "$(params)"
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

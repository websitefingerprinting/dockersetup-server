# Base docker image
FROM debian:stable-slim

# Install dependencies to add Tor's repository.
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    gpg-agent \
    ca-certificates \
    libcap2-bin \
    --no-install-recommends

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

# See: <https://2019.www.torproject.org/docs/debian.html.en>
RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN printf "deb https://deb.torproject.org/torproject.org stable main\n" >> /etc/apt/sources.list.d/tor.list

# Install remaining dependencies.
RUN apt-get update && apt-get install -y \
    tor \
    tor-geoipdb \
    --no-install-recommends

EXPOSE 35000


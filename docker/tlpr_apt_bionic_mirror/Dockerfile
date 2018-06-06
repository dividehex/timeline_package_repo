FROM ubuntu:18.04

MAINTAINER Jake Watkins <dividehex@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install required system tools and remove caches
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        tzdata \
        python3.6 \
        python3-distutils \
        python3-setuptools \
        python3-wheel \
        python3-pip \
        apt-mirror && \
    ln -fs /usr/share/zoneinfo/US/Pacific /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /etc/apt/mirror.list && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install awscli

COPY mirror.list /mirror.list
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir /data
VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

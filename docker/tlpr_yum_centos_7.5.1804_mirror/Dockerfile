FROM centos:7

MAINTAINER Jake Watkins <dividehex@gmail.com>

# Install required system tools and remove caches
RUN yum -y update && \
    yum -y install \
        rsync \
        yum-utils && \
    yum -y groupinstall development && \
    yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum -y install python36u && \
    yum -y install python36u-pip && \
    rm -rf /var/cache/yum /tmp/* /var/tmp/*

RUN pip3.6 install awscli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir /data
VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

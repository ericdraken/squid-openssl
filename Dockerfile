FROM arm32v7/ubuntu:18.04
LABEL maintainer="ericdraken@gmail.com"
LABEL repo="https://github.com/ericdraken/squid-openssl"

WORKDIR "/"

# Install squid
# The must match the folders in the squid.conf file
# Note: squid3: libssl1.0-dev, squid4: libssl-dev
ENV SQUID_FILE=squid-4.8.tar.gz \
    SQUID_FOLDER=v4 \
    SQUID_CACHE_DIR=/tmp/squid \
    SQUID_LOG_DIR=/tmp/log/squid \
    SQUID_USER=proxy \
    SQUID_BUILD_DEPS="libssl-dev build-essential libcrypto++-dev pkg-config autoconf g++"

# Install Ubuntu packages
RUN apt-get -qq update && \
	apt-get -y -qq install bash tar openssl $SQUID_BUILD_DEPS

ADD http://www.squid-cache.org/Versions/$SQUID_FOLDER/$SQUID_FILE /tmp/
# TODO: Verify the signature
# ADD http://www.squid-cache.org/Versions/$SQUID_FOLDER/$SQUID_FILE.asc /tmp/
# RUN gpg --import /tmp/$SQUID_FILE.asc 2>&1
# RUN gpg --verify /tmp/$SQUID_FILE.sig /tmp/$SQUID_FILE 2>&1
RUN tar xfz /tmp/$SQUID_FILE -C /tmp/
# This will take a very long time to build!
RUN cd /tmp/squid* && \
    ./configure \
        --with-default-user=$SQUID_USER \
        --with-openssl \
        --enable-ssl \
        --enable-ssl-crtd \
        --prefix=/squid && \
    make all && make install

# Cleanup
RUN apt-get -y -qq remove $SQUID_BUILD_DEPS && \
    apt-get -qq clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

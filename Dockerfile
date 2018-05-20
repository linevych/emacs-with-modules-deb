FROM debian:stable

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb-src http://cdn-fastly.deb.debian.org/debian stable main contrib" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends build-essential && \
    apt-get build-dep emacs25 -y

RUN mkdir /build
WORKDIR /build

RUN apt-get source emacs25 && \
    cd emacs25-*/debian && \
    sed -i '/confflags += --with-sound=alsa/a confflags += --with-modules' rules && \
    cd ../ && \
    dpkg-buildpackage -us -uc

FROM gcc:4.9
MAINTAINER na-g@nostrum.com
 
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

#Install build tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
	--no-install-recommends \
	autoconf2.13 \
	build-essential \
	distcc \
	ccache \
	wget \
	mercurial \
	python \
	python-dev \
	python-pip \
	ca-certificates \
	zip \
	unzip \
	pkg-config \
	yasm

# Install build dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
	--no-install-recommends \
	libgtk-3-dev \
	libgtk2.0-dev \
	libgconf2-dev \
	libdbus-glib-1-dev \
	libasound2-dev \
	libpulse-dev \
	libgstreamer0.10-dev \
	libgstreamer-plugins-base0.10-dev \
	libxt-dev

#Update mercurial
RUN pip install --upgrade Mercurial

#Create the non-root build user
RUN useradd -ms /bin/bash build
RUN chmod 777 /home/build
USER build
WORKDIR /home/build
#Exporting the build home volume
VOLUME /home/build
#Allow mach to build without setting up mercurial
ENV I_PREFER_A_SUBOPTIMAL_MERCURIAL_EXPERIENCE=true

#Export a shell so that mach can identify the system as Linux
ENV SHELL=/bin/bash

LABEL na-g.mozilla-central-build.version="0.1"

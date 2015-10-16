FROM enaygee/mozilla-central-build:0.1
MAINTAINER na-g@nostrum.com
USER root 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends supervisor
#Where to mount the supervisor config
VOLUME /etc/supervisor/conf.d
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf
#Expose the DISTCC port
EXPOSE 3632
#Expose the DISTCC stats port
EXPOSE 3633

CMD ["/usr/bin/supervisord"]

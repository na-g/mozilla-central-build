#Distcc server for building the mozilla-central repo
The purpose of this server is to use the mozilla-central-build containerized environment to host a distcc server.  This keeps the build tools homogenous across the hosts.
#Configuration
The only configuration that needs to be done is editing the whitelist of allowed networks in the supervisor.conf file. The whitelist takes the form of a list of --allow (CIDRNET) flags.  The configuration is loaded  by mounting the /etc/supervisor/conf.d/ volume, and copying your customized configuration into your mount point.
#Running the container
1. Edit the supervisord config, to whitelist the machines you will be connecting from.

```ini
[supervisord]
nodaemon=true
[program:distccd]
command=/usr/bin/distccd --no-detach --stats --daemon --allow 127.0.0.1 --allow 192.168.0.0/16
```
2. Run the container

```sh
#Assuming that the edited config is in `pwd`/conf/supervisor.conf
docker run -d --name mozdistcc \
  -v `pwd`/conf:/etc/supervisor/conf.d/ \
  -p 3632:3632 -p 3633:3633 \
  enaygee/mozilla-build-distcc
```
3. Test that it is reachable by pulling the stats

```ssh
telnet locahost 3633
```

If the connection is closed without recieving statistics, that means you can reach the port but are not whitelisted.


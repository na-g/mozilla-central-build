# Dockerized Mozilla Linux build environtment

Building in a Dockerized environment has several benefits.

  1. It eliminates exposure to libraries installed on the host system.
  2. Consolidates project specific tool chain configuration.
  3. The Dockerized environment can be created once and run on any machine with docker.

__Note:__ if you are using OS X and docker-machine or boot2docker, then you will experience an extreme slowdown to file access. This is a known issue, and one work around would be to use [docker-osx-dev](https://github.com/brikis98/docker-osx-dev).  Additionally, at this time only mount points inside of /User work on the OS X side.

## Getting the container
The container can be pulled from [Docker Hub](https://hub.docker.com/r/enaygee/mozilla-central-build/), and given a more convenient tag.

```sh
#Pull the container from dockerhub
docker pull enaygee/mozilla-central-build
#After tagging one can reference the container as mozbild
docker tag enaygee/mozilla-central-build mozbild
```

Alternatively, you can build it from the Dockerfile.

```sh
git clone https://github.com/na-g/mozilla-central-build.git
cd mozilla-central-build && docker build -t mozbild .
```

## Checking out the code
One needs to create a local directory to hold the source tree. Then one attach the source tree as a Docker volume to the container and run a mercurial clone. Even on a fast connection this can take over 10 minutes.
The SRC_MOUNT is a pair of directories, the first is a directory __outside__ of the docker container, and the second is the directory it will be mapped to inside the container.

```sh
SRC_MOUNT=`pwd`/build:/home/build
mkdir build
docker run -it -v ${SRC_MOUNT} mozbild hg clone https://hg.mozilla.org/mozilla-central
```
This will checkout the mozilla-central repository inside the build directory.

## Running a build
After checking out the code one can build it like so:

```sh
SRC_MOUNT=`pwd`/build:/home/build
docker run -it -v ${SRC_MOUNT} mozbild \
	/bin/bash -c "cd mozilla-central && ./mach build"
```
Everything is executed as the user "build" inside of the container.

## Customizing your configuration

You can add a [.mozconfig](https://developer.mozilla.org/en-US/docs/Configuring_Build_Options), and mercurial configuration to your SRC_MOUNT if you want to customize the build. ccache is installed, and can be turned on in the .mozbuild file.

```sh
#Must be an absolute path
export MOZCONFIG=/home/build/mozconfig
docker run -it -v ${SRC_MOUNT} -e MOZCONFIG=$MOZCONFIG
```


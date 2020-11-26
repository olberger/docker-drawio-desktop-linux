This project is fully inspired of Marc Douchement's [docker-zoom-us](https://github.com/mdouchement/docker-zoom-us), which in turn was inspired by [sameersbn](https://github.com/sameersbn) [Skype](https://github.com/sameersbn/docker-skype)'s containerization.

# olberger/docker-drawio-linux

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image with [Draw.io desktop](http://get.diagrams.net/) for Linux.

The image uses [X11](http://www.x.org) unix domain socket on the host to enable display of the Draw.io desktop app. These components are available out of the box on pretty much any modern linux distribution.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](https://github.com/olberger/docker-drawio-desktop-linux/issues?q=is%3Aopen+is%3Aissue).

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/olberger/docker-drawio-desktop-linux) and is the recommended method of installation.

```bash
docker pull olberger/docker-drawio-desktop-linux:latest
```

Alternatively you can build the image yourself.

```bash
docker build -t olberger/docker-drawio-desktop-linux github.com/olberger/docker-drawio-desktop-linux
```

With the image locally available, install the wrapper scripts by running the following as root:

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  olberger/docker-drawio-desktop-linux:latest install
```

This will install a wrapper script to launch `drawio`.

## Starting Drawio

Launch the drawio-wrapper script to enter a shell inside the Docker container

```bash
drawio-wrapper bash
```

Then the prompt should be displayed like:
```
Adding user `drawio' to group `sudo' ...
Adding user drawio to group sudo
Done.
bash
launch draw.io by invoking 'drawio' at the bash prompt:
drawio@0b2fefbf45d2:~$
```

then type `drawio`.


> **Note**
>
> If Draw.io is installed on the the host then the host binary is launched instead of starting a Docker container. To force the launch of Draw.io in a container use the `drawio-wrapper` script. For example, `drawio-wrapper teams` will launch Draw.io inside a Docker container regardless of whether it is installed on the host or not.


## How it works

The wrapper scripts volume mount the X11 socket in the launcher container. The X11 socket allows for the user interface display on the host.

When the image is launched the following directories are mounted as volumes

- `${HOME}/.config/draw.io`
- the `${PWD}/diagrams-from-host/` subdir, i.e. a subdir of the current directory
<!-- - `XDG_DOWNLOAD_DIR` or if it is missing `${HOME}/Downloads` -->
<!-- - `XDG_DOCUMENTS_DIR` or if it is missing `${HOME}/Documents` -->

This makes sure that the configuration of the tool are stored on the host and files saved are preserved in the current suddir, if places inside the special 'diagrams-from-host/' directory.

**Don't want to expose host's folders to Draw.io application?**

Add `DRAWIO_HOME` environment variable to namespace all draw.io folders:

```sh
export DRAWIO_HOME=${HOME}/draw.io
```


# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull olberger/docker-drawio-desktop-linux:latest
  ```

  2. Run `install` to make sure the host scripts are updated.

  ```bash
  docker run -it --rm \
    --volume /usr/local/bin:/target \
    olberger/docker-drawio-desktop-linux:latest install
  ```

## Uninstallation

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  olberger/docker-drawio-desktop-linux:latest uninstall
```


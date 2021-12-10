# ansible-labe

## Installation

### Setup

Before you start your first `systemd` container, run the following command to set up your Docker host. It uses [special privileges](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) to create a cgroup hierarchy for `systemd`. We do this in a separate setup step so we can run `systemd` in unprivileged containers.

```bash
$ docker run --rm --privileged -v /:/host vwnio/hosts:ansible setup
```

### Start

Start the ansible lab with:

```bash
$ docker-compose up
```

You can now navigate to [ubuntu-c](http://localhost:7681), [ubuntu](http://localhost:7682) and [centos](http://localhost:7683)
ARG VARIANT
FROM python:${VARIANT}-alpine as BUILD

WORKDIR /provision

ENV USER=provision
ENV UID=1000
ENV GID=1000

# Install required packages
RUN apk add --no-cache jq openssh bind-tools sshpass bash sudo

# Install/build Ansible
RUN apk add --no-cache --virtual .build-deps libffi-dev gcc musl-dev \
  && pip3 install ansible \
  && apk del .build-deps libffi-dev gcc musl-dev

# Create 'provision' user
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/provision" \
    --shell /bin/bash \
    --uid "$UID" \
    "$USER" \
    && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

USER provision

VOLUME /provision
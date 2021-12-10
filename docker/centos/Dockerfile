FROM centos:8 as prod

ENV container=docker
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

# Install packages
RUN yum install -y \
  dbus \
  dos2unix \
  openssh-clients \
  openssh-server \
  openssl \
  sudo \
  systemd \
  && yum clean all \
  && rm -rf /tmp/*/ var/tmp/*

RUN systemctl set-default multi-user.target

# Create folder for utilities
RUN mkdir -p /utils

# Install ttyd
ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 /utils/
ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.aarch64 /utils/
RUN ln -s /utils/ttyd.$(uname -m) /utils/ttyd
COPY files/login /utils/
COPY files/setup /sbin/
COPY files/*.service /usr/lib/systemd/system/
COPY files/*.sh /utils/

# Fix permissions
RUN chmod 0755 /sbin/setup /utils/ttyd* /utils/startup.sh /utils/healthcheck.sh

# Enable services
RUN systemctl enable startup.service
RUN systemctl enable healthcheck.service
RUN systemctl enable hostname_capture.service

# # Cleanup MOTD
# RUN find /etc/update-motd.d \
#     -not -name '00-header' \
#     -not -name '10-help-text' \
#     -not -name '50-motd-news' \
#     -exec rm \{} \;

STOPSIGNAL SIGRTMIN+3

CMD ["/usr/lib/systemd/systemd"]
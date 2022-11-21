ARG OS_DIST=debian
ARG OS_TAG=bullseye
FROM $OS_DIST:$OS_TAG AS base

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
ARG TERM=linux

RUN apt-get --quiet --yes update
RUN apt-get --quiet --yes dist-upgrade
RUN apt-get --quiet --no-install-recommends --yes install apt-utils
RUN apt-get --quiet --no-install-recommends --yes install debconf-utils
RUN apt-get --quiet --yes update

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections
RUN echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections
RUN apt-get --quiet --no-install-recommends --yes install locales
RUN rm --force /etc/locale.gen
ARG LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/America select Chicago' | debconf-set-selections
# Remove these files first, they should be regenerated after reconfiguration
RUN rm --force /etc/localtime
RUN rm --force /etc/timezone
ARG TZ=Amercia/Chicago
RUN dpkg-reconfigure tzdata

RUN apt-get --no-install-recommends --quiet --yes install cron
RUN apt-get --no-install-recommends --quiet --yes install lynx
RUN apt-get --no-install-recommends --quiet --yes install python3
RUN apt-get --no-install-recommends --quiet --yes install python3-dev
RUN apt-get --no-install-recommends --quiet --yes install python3-pip
RUN apt-get --no-install-recommends --quiet --yes install python3-venv
RUN apt-get --no-install-recommends --quiet --yes install sqlite3
RUN apt-get --no-install-recommends --quiet --yes install sudo
RUN apt-get --no-install-recommends --quiet --yes install vim

RUN apt-get --quiet clean
RUN apt-get --quiet autoremove
RUN rm --force --recursive /tmp/*
RUN rm --force --recursive /var/lib/apt/lists/*
RUN rm --force --recursive /var/tmp/*

# RUN echo 'ulimit -c 0' > /dev/null 2>&1 > /etc/profile.d/disable-coredumps.sh
# RUN chmod 777 /etc/profile.d/disable-coredumps.sh
# For easy administration / getting into root user.
# WARNING: Do not use this in production.
RUN echo root:root | chpasswd
COPY ./.bashrc /root

ARG USERNAME=admin
ARG USERHOME="/home/${USERNAME}"
ARG GROUPNAME=$USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USERPASS=admin

# Remove mail spool creation and error message from `useradd`
RUN sed --in-place 's/^CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/' /etc/default/useradd
RUN groupadd --gid $USER_GID $GROUPNAME
RUN useradd --create-home --shell /bin/bash --uid $USER_UID --gid $GROUPNAME $USERNAME
RUN usermod --append --groups sudo $USERNAME
RUN echo "${USERNAME}:${USERPASS}" | chpasswd

# NOTE: Tab character after the username.
# NOTE: Must install the `sudo` package for this to work.
RUN echo "${USERNAME}\tALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}"
RUN chmod 0440 "/etc/sudoers.d/${USERNAME}"
# Or for all files in sudoers.d
# RUN chmod --recursive 0440 /etc/sudoers.d/

# Finally switch to user and working directory to user home.
USER $USERNAME
WORKDIR $USERHOME
# COPY ./.bashrc ./
# COPY ./scripts/test.sh ./

# Copy all files not excluded by ``.dockerignore``.
COPY ./ ./
# Ensure user has ownership of home directory and files.
RUN sudo chown --recursive $USERNAME $USERHOME
RUN sudo chmod 755 --recursive $USERHOME

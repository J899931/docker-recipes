ARG OS_DIST=debian
ARG OS_TAG=bullseye
FROM $OS_DIST:$OS_TAG

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
# RUN ln --force --no-dereference --symbolic /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN dpkg-reconfigure tzdata

RUN apt-get --no-install-recommends --quiet --yes install openssh-server
RUN apt-get --no-install-recommends --quiet --yes install sudo
RUN apt-get --no-install-recommends --quiet --yes install vim

RUN apt-get --quiet --quiet clean
RUN apt-get --quiet --quiet autoremove
RUN rm --force --recursive /tmp/*
RUN rm --force --recursive /var/lib/apt/lists/*
RUN rm --force --recursive /var/tmp/*

RUN echo root:root | chpasswd
COPY .bashrc /root

ARG SRV_SFTP_DIR=/srv/sftp
RUN mkdir --parents $SRV_SFTP_DIR
RUN chown --recursive root:root $SRV_SFTP_DIR
RUN chmod 755 $SRV_SFTP_DIR

ARG SAGE_SFTP_DIR=$SRV_SFTP_DIR/sage
RUN mkdir --parents $SAGE_SFTP_DIR
RUN chown --recursive root:root $SAGE_SFTP_DIR
RUN chmod 755 $SAGE_SFTP_DIR

ARG AUTHORIZED_KEYS_DIR=/etc/ssh/authorized_keys
RUN mkdir --parents $AUTHORIZED_KEYS_DIR
RUN chown --recursive root:root $AUTHORIZED_KEYS_DIR
RUN chmod 600 $AUTHORIZED_KEYS_DIR

# - OpenSSH needs /var/run/sshd to run
RUN mkdir --parents /var/run/sshd
RUN chmod 755 /var/run/sshd

ARG GROUPNAME=sftp
ARG GROUP_GID=2000
RUN groupadd --gid $GROUP_GID $GROUPNAME

ARG USERNAME=sage
ARG USERHOME=$SAGE_SFTP_DIR/$USERNAME
ARG USERPASS=pass
ARG USER_UID=2001

# Remove mail spool creation and error message from `useradd`
RUN sed --in-place 's/^CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/' /etc/default/useradd
# Let the user shell be /bin/false as the users should only be allowed to do sftp and not ssh/scp.
RUN useradd --create-home --home $USERHOME --shell /bin/false --uid $USER_UID --gid $GROUPNAME $USERNAME
RUN echo "$USERNAME:$USERPASS" | chpasswd
# RUN usermod --append --groups sftp $USERNAME

RUN mkdir --parents $USERHOME
RUN mkdir --parents $USERHOME/downloads
RUN mkdir --parents $USERHOME/uploads
RUN chown --recursive $USERNAME $USERHOME
RUN chmod 755 --recursive $USERHOME

COPY ./03_docker_sftp/sshd_config /etc/ssh/sshd_config
RUN dpkg-reconfigure openssh-server

COPY ./scripts/sftp/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]

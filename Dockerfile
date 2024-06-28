FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 

# Mandatory installs
RUN apt-get install -y transmission-daemon openvpn iptables python3 python3-dev python3-venv cron minidlna samba avahi-daemon dbus gcc

# Flexget > 3.10.7 doesn't build on 32b ARM
RUN python3 -m venv /opt/flexget && /opt/flexget/bin/pip install flexget==3.10.7 transmission-rpc==4.3.1

# Nice to have
RUN apt-get install -y nano iproute2 iputils-ping

# Copy config files
COPY config/transmission.json   /etc/transmission-daemon/settings.json
COPY config/flexget.yml         /root/.flexget/config.yml
COPY config/openvpn             /etc/openvpn
COPY config/crontab             /etc/cron.d/crontab
COPY config/minidlna.conf       /etc/minidlna.conf
COPY config/smb.conf            /etc/samba/smb.conf
COPY config/openvpn.default     /etc/default/openvpn

# Install cron table
RUN crontab < /etc/cron.d/crontab

# Copy scripts
COPY scripts /root
RUN chmod +x /root/*.sh

VOLUME /public

RUN chmod 777 /public

# Entry point
CMD ["/root/start.sh"]

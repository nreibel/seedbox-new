#!/bin/bash

# Start VPN client
service openvpn start

# Wait for VPN to be up
sleep 5

# Set up iptables
iptables -F
iptables -A OUTPUT -m owner --uid-owner debian-transmission -d 127.0.0.0/24 -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner debian-transmission -d 192.168.0.0/16 -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner debian-transmission \! -o tun0 -j REJECT

ip6tables -F
ip6tables -A OUTPUT -m owner --uid-owner debian-transmission -d fe80::/64 -j ACCEPT
ip6tables -A OUTPUT -m owner --uid-owner debian-transmission \! -o tun0 -j REJECT

# iptables -F
# iptables -A OUTPUT -o tun0 -j ACCEPT
# iptables -A INPUT -i tun0 -j ACCEPT
# iptables -A INPUT -s 172.29.0.0/16 -j ACCEPT
# iptables -A OUTPUT -d 172.29.0.0/16 -j ACCEPT
# iptables -A INPUT -i lo -j ACCEPT
# iptables -A OUTPUT -o lo -j ACCEPT
# iptables -A OUTPUT -m owner --uid-owner debian-transmission \! -o tun0 -j REJECT

# Start other services
service transmission-daemon start
service minidlna start
service smbd start
service cron start
service dbus start
service ssh start

avahi-daemon --no-chroot -D

# Keep container running
tail -f /dev/null

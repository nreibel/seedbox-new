#!/bin/bash

IMAGE="seedbox"
NETWORK="local-net"
HOSTNAME="seedbox"
SHARE="/public"
IP="192.168.1.2"
SUBNET="192.168.1.0/24"
GATEWAY="192.168.1.1"

docker build -t $IMAGE .

if ! docker network list | grep $NETWORK >/dev/null 2>&1
then docker network create -d macvlan --subnet $SUBNET --gateway $GATEWAY -o parent=eth0 $NETWORK
fi

docker run -d                 \
  --privileged                \
  --restart    unless-stopped \
  --hostname   $HOSTNAME      \
  --network    $NETWORK       \
  --ip         $IP            \
  --volume     $SHARE:/public \
  $IMAGE

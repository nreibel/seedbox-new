#!/bin/bash

# Update system packages
apt-get update
apt-get upgrade -y

# Update Flexget
source /opt/flexget/bin/activate
pip install --upgrade flexget
deactivate

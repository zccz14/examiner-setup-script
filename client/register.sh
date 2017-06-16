#!/usr/bin/env bash

# load config
source ../config/client-network.conf

echo connecting to ${CLI_SSH_HOST} for account registration

# configure server ssh public key
mkdir -p ~/.ssh/
ssh-keygen -R ${CLI_SSH_HOST} 
ssh-keyscen -H ${CLI_SSH_HOST} >> ~/.ssh/known_hosts


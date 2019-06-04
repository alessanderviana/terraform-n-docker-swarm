#!/usr/bin/env bash

# Get unaccepted keys
NODE_KEYS=$( salt-key -l un | grep -c cluster )

# If is not empty accept the node keys
if [ $NODE_KEYS -ge 1 ]; then
  salt-key -A -y
  echo ""
fi

# Initialize the leader cluster
docker swarm init
echo ""

# Get the worker token
TOKEN=$( docker swarm join-token worker | grep join )

# Get the swarm nodes (no leaders)
SWARM_NODES=$( salt-key -l acc | grep -v Keys | grep -v cluster-1 )

# Join the nodes to the cluster
echo "Joining nodes ..."
for I in $( echo $SWARM_NODES ); do salt "$I" cmd.run "${TOKEN}"; done

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

echo "Waiting 7 seconds ..."
for i in {1..7}; do echo -n .; sleep 1; done; echo ""

# Join the nodes to the cluster
echo "Joining nodes ..."
for I in $( echo $SWARM_NODES ); do salt "$I" cmd.run "${TOKEN}"; done

# Next steps
# docker service create --name phoenix-app -p 4000:4000 --replicas 4 registry.gitlab.com/alessanderviana/sre-challenge/elixir-phoenix:latest
# echo "0/30 * * * * root docker run -ti registry.gitlab.com/alessanderviana/sre-challenge/elixir-phoenix:latest mix talk" >> /etc/crontab

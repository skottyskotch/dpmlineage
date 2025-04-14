#!/bin/bash

set -e

echo "=== Stopping Neo4j service (if running) ==="
sudo systemctl stop neo4j || true

echo "=== Removing Neo4j package if installed ==="
if dpkg -l | grep -q neo4j; then
  sudo apt purge -y neo4j
fi

echo "=== Cleaning up configuration and data directories ==="
sudo rm -rf /etc/neo4j /var/lib/neo4j /var/log/neo4j

echo "=== Removing repository and key if they exist ==="
sudo rm -f /etc/apt/sources.list.d/neo4j.list
sudo rm -f /usr/share/keyrings/neo4j.gpg
sudo apt update

echo "=== Closing ports if UFW is active ==="
if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -q 'Status: active'; then
  sudo ufw status | grep -q "7474/tcp" && sudo ufw delete allow 7474/tcp
  sudo ufw status | grep -q "7687/tcp" && sudo ufw delete allow 7687/tcp
else
  echo "UFW not installed or inactive — skipping port cleanup."
fi

echo "=== Neo4j successfully removed ==="

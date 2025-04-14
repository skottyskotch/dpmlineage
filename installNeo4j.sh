#!/bin/bash
set -e

echo "=== Updating system packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Adding Neo4j official repository (if not present) ==="
if [ ! -f /usr/share/keyrings/neo4j.gpg ]; then
  wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
fi

if [ ! -f /etc/apt/sources.list.d/neo4j.list ]; then
  echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable 5" | sudo tee /etc/apt/sources.list.d/neo4j.list
fi

echo "=== Installing Neo4j Community Edition ==="
sudo apt update
sudo apt install -y neo4j

echo "=== Disabling authentication if not already disabled ==="
sudo grep -q '^dbms.security.auth_enabled=false' /etc/neo4j/neo4j.conf || \
  sudo sed -i 's/^#\?dbms.security.auth_enabled=.*/dbms.security.auth_enabled=false/' /etc/neo4j/neo4j.conf

echo "=== Enabling remote access if not already enabled ==="
sudo grep -q '^dbms.default_listen_address=0.0.0.0' /etc/neo4j/neo4j.conf || \
  sudo sed -i 's/^#\?dbms.default_listen_address=.*/dbms.default_listen_address=0.0.0.0/' /etc/neo4j/neo4j.conf

echo "=== Enabling and restarting Neo4j service ==="
sudo systemctl enable neo4j
sudo systemctl restart neo4j

echo "=== Opening ports if UFW is active ==="
if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -q 'Status: active'; then
  sudo ufw allow 7474/tcp || true
  sudo ufw allow 7687/tcp || true
else
  echo "UFW not installed or not active — skipping firewall configuration."
fi

echo "=== Installation complete ==="
echo "→ Web UI:  http://<your-server-ip>:7474"
echo "→ Bolt:    bolt://<your-server-ip>:7687"

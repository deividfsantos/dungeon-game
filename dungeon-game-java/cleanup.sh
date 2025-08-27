#!/bin/bash

echo "🧹 Cleaning up Docker resources..."

# Stop all containers
echo "→ Stopping containers..."
docker compose down

# Remove volumes (this will delete database data)
echo "→ Removing volumes..."
docker compose down -v

# Remove orphaned containers
echo "→ Removing orphaned containers..."
docker container prune -f

# Remove unused images
echo "→ Removing unused images..."
docker image prune -f

# Remove unused networks
echo "→ Removing unused networks..."
docker network prune -f

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "⚠️  Note: Database data has been removed."
echo "   Run ./setup.sh or ./setup-monitoring.sh to restart."

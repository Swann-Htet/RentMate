#!/bin/sh
set -e

echo "==> Waiting for MySQL port ${DB_HOST:-db}:3306 to open..."
until nc -z "${DB_HOST:-db}" 3306 2>/dev/null; do
  echo "   MySQL not reachable yet — retrying in 2s..."
  sleep 2
done
echo "   MySQL port is open — waiting 3s for full initialization..."
sleep 3

echo "==> Running database setup..."
node backend/scripts/setupDatabase.js
echo "   Database setup complete."

echo "==> Starting RentMate server..."
exec node backend/server.js

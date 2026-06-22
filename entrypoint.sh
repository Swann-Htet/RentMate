#!/bin/sh
set -e

echo "==> Waiting for MySQL to be ready..."
# The docker-compose healthcheck already ensures MySQL is up before this
# container starts, but a brief retry loop guards against edge cases.
until node -e "
  const mysql = require('mysql2/promise');
  mysql.createConnection({
    host: process.env.DB_HOST || 'db',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || ''
  }).then(c => { c.end(); process.exit(0); }).catch(() => process.exit(1));
" 2>/dev/null; do
  echo "   MySQL not ready yet — retrying in 2s..."
  sleep 2
done
echo "   MySQL is ready."

echo "==> Running database setup..."
node backend/scripts/setupDatabase.js
echo "   Database setup complete."

echo "==> Starting RentMate server..."
exec node backend/server.js

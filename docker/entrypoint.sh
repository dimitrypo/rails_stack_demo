#!/bin/bash
set -e

# Remove any existing server.pid
rm -f /app/tmp/pids/server.pid

# Run database migrations
bundle exec rails db:prepare

# Ensure Tailwind output file exists immediately, then build in background
echo "Ensuring Tailwind CSS placeholder exists..."
mkdir -p ./app/assets/builds
if [ ! -f ./app/assets/builds/tailwind.css ]; then
	echo "/* placeholder - replaced by background tailwind build */" > ./app/assets/builds/tailwind.css
fi

echo "Starting Tailwind CSS build in background..."
bundle exec rails tailwindcss:build &
TAILWIND_BUILD_PID=$!
echo "Tailwind build PID: $TAILWIND_BUILD_PID"

# Start Sidekiq in background
echo "Starting Sidekiq..."
bundle exec sidekiq &

# Give background tasks a moment to spin up (optional)
sleep 1

# Start Rails server (in foreground)
echo "Starting Rails server..."
bundle exec rails server -b 0.0.0.0
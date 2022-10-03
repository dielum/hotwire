#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /hotwire/tmp/pids/server.pid

exec "$@"
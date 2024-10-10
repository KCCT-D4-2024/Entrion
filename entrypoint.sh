#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

rails db:create
rails db:migrate


exec "$@"

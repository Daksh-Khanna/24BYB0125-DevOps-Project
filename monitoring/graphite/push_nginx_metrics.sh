#!/bin/bash
# ---- Push nginx active-connections/requests metrics into Graphite ----
# Run as a cron job every minute on the host, or as a K8s CronJob.
#
# Usage: ./push_nginx_metrics.sh <site-url> <carbon-host> <carbon-port>

SITE_URL="${1:-http://localhost:30080/nginx_status}"
CARBON_HOST="${2:-127.0.0.1}"
CARBON_PORT="${3:-2003}"
TIMESTAMP=$(date +%s)

STATUS=$(curl -s "$SITE_URL")

ACTIVE=$(echo "$STATUS" | awk '/Active connections/ {print $3}')
REQUESTS=$(echo "$STATUS" | awk 'NR==3 {print $3}')

if [ -n "$ACTIVE" ]; then
  echo "portfolio.nginx.active_connections $ACTIVE $TIMESTAMP" | nc -q1 "$CARBON_HOST" "$CARBON_PORT"
fi

if [ -n "$REQUESTS" ]; then
  echo "portfolio.nginx.total_requests $REQUESTS $TIMESTAMP" | nc -q1 "$CARBON_HOST" "$CARBON_PORT"
fi

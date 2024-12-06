#!/bin/sh
set -e

# Set timezone if provided
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
fi

# Initialize any first-time configurations if needed
if [ ! -d "/run/supervisor" ]; then
    mkdir -p /run/supervisor
fi

# Process Keepalived configuration
envsubst < /etc/keepalived/keepalived.conf_tpl > /etc/keepalived/keepalived.conf

# Process HAProxy configuration
envsubst < /usr/local/etc/haproxy/haproxy.cfg_tpl > /usr/local/etc/haproxy/haproxy.cfg

# Start supervisord in the foreground
exec /usr/bin/supervisord -n -c /etc/supervisord.conf

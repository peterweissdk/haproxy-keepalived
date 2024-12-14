#!/bin/sh

set -e

# Check if HAProxy is running and responding
haproxy_check() {
    if ! pgrep haproxy >/dev/null; then
        echo "HAProxy is not running"
        exit 1
    fi
    
    # Check if HAProxy stats socket is responding
    if ! echo "show info" | socat unix-connect:/var/run/haproxy.sock stdio >/dev/null 2>&1; then
        echo "HAProxy socket is not responding"
        exit 1
    fi
}

# Check if Keepalived is running
keepalived_check() {
    if ! pgrep keepalived >/dev/null; then
        echo "Keepalived is not running"
        exit 1
    fi
}

# Run all checks
haproxy_check
keepalived_check

echo "Health check passed"
exit 0


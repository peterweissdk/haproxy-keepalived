FROM haproxy:lts-alpine

USER root

# Install required packages
RUN apk add --no-cache \
    keepalived \
    supervisor \
    ipvsadm \
    iproute2 \
    gettext && \
    rm -rf /var/cache/apk/*

# Create necessary directories for supervisor
RUN mkdir -p /etc/supervisor.d /run/supervisor

# Copy supervisor configuration files
COPY supervisord.conf /etc/supervisord.conf
COPY conf/supervisor/* /etc/supervisor.d/

# Copy HAProxy and Keepalived configurations
COPY conf/haproxy/haproxy.cfg_tpl /usr/local/etc/haproxy/haproxy.cfg_tpl
COPY conf/keepalived/keepalived.conf_tpl /etc/keepalived/keepalived.conf_tpl

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose ports
EXPOSE 80 443

# Set entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]

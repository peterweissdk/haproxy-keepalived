FROM haproxy:alpine3.20

ARG version
ARG buildDate

LABEL "org.opencontainers.image.title"="haproxy-keepalived"
LABEL "org.opencontainers.image.description"="HAProxy load balancing with Keepalived for high availability"
LABEL "org.opencontainers.image.vendor"="Peter Weiss"
LABEL "org.opencontainers.image.version"=${version}
LABEL "org.opencontainers.image.created"=${buildDate}
LABEL "org.opencontainers.image.url"
LABEL "org.opencontainers.image.source"="https://github.com/peterweissdk/haproxy-keepalived"
LABEL "org.opencontainers.image.revision"
LABEL "org.opencontainers.image.documentation"
LABEL "org.opencontainers.image.license"="GNU GENERAL PUBLIC LICENSE v3.0"

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

# Alpine baseimage. Kernel 6.12 LTS
FROM alpine:3.21

# Build arguments
ARG version
ARG buildDate
ARG revision

# Add labels
LABEL "org.opencontainers.image.title"="haproxy-keepalived" \
  "org.opencontainers.image.description"="HAProxy load balancing with Keepalived for high availability" \
  "org.opencontainers.image.vendor"="Peter Weiss" \
  "org.opencontainers.image.version"=${version} \
  "org.opencontainers.image.created"=${buildDate} \
# (Docker HUB) LABEL "org.opencontainers.image.url"
  "org.opencontainers.image.source"="https://github.com/peterweissdk/haproxy-keepalived" \
  "org.opencontainers.image.revision"=${revision} \
# LABEL "org.opencontainers.image.documentation"
  "org.opencontainers.image.license"="GNU GENERAL PUBLIC LICENSE v3.0"

# Install required packages
RUN apk add --no-cache \
    haproxy=3.0.7-r0 \
    keepalived=2.3.1-r0 \
    supervisor=4.2.5-r5 \
    ipvsadm=1.31-r3 \
    iproute2=6.11.0-r0 \
    gettext=0.22.5-r0 \
    socat=1.8.0.1-r0 && \
    rm -rf /var/cache/apk/*

# Create necessary directories for supervisor
RUN mkdir -p /etc/supervisor.d /run/supervisor

# Create HAProxy socket directory
RUN mkdir -p /var/run && \
    touch /var/run/haproxy.sock && \
    chmod 666 /var/run/haproxy.sock

# Copy supervisor configuration files
COPY supervisord.conf /etc/supervisord.conf
COPY conf/supervisor/* /etc/supervisor.d/

# Copy HAProxy and Keepalived configurations
COPY conf/haproxy/haproxy.cfg_tpl /usr/local/etc/haproxy/haproxy.cfg_tpl
COPY conf/keepalived/keepalived.conf_tpl /etc/keepalived/keepalived.conf_tpl

# Copy health check script
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD /healthcheck.sh

# Expose port for HAProxy stats
EXPOSE 8880

# Set entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]

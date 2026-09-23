FROM debian:bookworm-slim

# dante-server — официальный пакет Debian (Dante 1.4.x, версия контролируется
# меткой базового образа); netcat-openbsd нужен для TCP-healthcheck из compose
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        dante-server \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 50107

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

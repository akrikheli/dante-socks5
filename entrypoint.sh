#!/bin/sh
set -e

# Пользователь для SOCKS-авторизации создаётся на старте контейнера
# из переменных окружения, чтобы креды не запекались в слои образа
# (иначе пароль виден в `docker history`).

# Системный пользователь, под которым работает sockd
# (user.unprivileged: sockd в sockd.conf). Пакет dante-server его обычно
# создаёт, но проверяем на случай отличий в версии пакета.
if ! id -u sockd >/dev/null 2>&1; then
    adduser --system --group --no-create-home --home /nonexistent --shell /usr/sbin/nologin sockd
fi

if [ -z "$SOCKS_USER" ] || [ -z "$SOCKS_PASS" ]; then
    echo "ERROR: SOCKS_USER and SOCKS_PASS must be set" >&2
    exit 1
fi

# idempotent: при рестарте контейнера (без пересоздания) пользователь уже есть
if ! id -u "$SOCKS_USER" >/dev/null 2>&1; then
    adduser --system --group --no-create-home --home /nonexistent --shell /usr/sbin/nologin "$SOCKS_USER"
fi
echo "$SOCKS_USER:$SOCKS_PASS" | chpasswd

# В пакете dante-server (Debian) бинарник называется danted
exec /usr/sbin/danted -f /etc/sockd.conf

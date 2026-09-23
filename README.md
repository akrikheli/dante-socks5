# dante-socks5

SOCKS5-прокси на базе [Dante](https://www.inet.no/dante/) (пакет `dante-server` из Debian bookworm, v1.4.2) с авторизацией по логину/паролю, упакованный в Docker.

## Требования

- Docker
- Docker Compose

## Настройка

Создайте файл `.env` в корне проекта (в репозиторий не коммитится — см. `.gitignore`):

```bash
cp .env.example .env
```

И заполните свои значения:

```dotenv
PROXY_USER=myuser
PROXY_PASS=mypassword
```

Эти переменные передаются в контейнер как переменные окружения (`SOCKS_USER` / `SOCKS_PASS`). Пользователь для SOCKS-авторизации создаётся entrypoint-скриптом при старте контейнера — креды не запекаются в образ и не видны в `docker history`.

Смена пароля не требует пересборки образа — просто обновите `.env` и перезапустите:

```bash
docker compose up -d --force-recreate
```

## Запуск

Собрать и запустить в фоне:

```bash
docker compose up -d --build
```

Прокси слушает порт **50107** на хосте (`0.0.0.0:50107 -> 50107`).

Проверка:

```bash
curl -x socks5h://myuser:mypassword@127.0.0.1:50107 https://ifconfig.me
```

## Остановка

```bash
docker compose down
```

## Конфигурация

Основной конфиг Dante — `sockd.conf`, монтируется в контейнер read-only (`/etc/sockd.conf`), поэтому его можно править без пересборки образа — достаточно перезапустить контейнер:

```bash
docker compose restart
```

`sockd.conf.orig` — старый конфиг из прежнего базового образа (`wernight/dante`), оставлен для справки и может быть удалён.

## Полезное

- Логи: `docker compose logs -f socks5-proxy`
- Контейнер ограничен 512M памяти, логи ротируются (10M × 3 файла)

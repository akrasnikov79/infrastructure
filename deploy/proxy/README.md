# Proxy Infrastructure with API Gateway

Этот модуль содержит Nginx proxy и API Gateway (Ocelot) для маршрутизации запросов к микросервисам.

## Архитектура

- **Nginx**: Обратный прокси-сервер (порты 80/443)
- **API Gateway (Ocelot)**: Маршрутизация API запросов (порт 5000)
- **Keycloak**: Сервис аутентификации и авторизации

## Маршрутизация

### Nginx (Entry Point)
- `/api/*` → API Gateway (Ocelot)
- `/auth/*` → Keycloak
- `/` → Keycloak (по умолчанию)

### API Gateway (Ocelot)
- `/api/auth/*` → Keycloak
- `/api/users/*` → Users Service
- `/api/clients/*` → Clients Service
- `/api/health` → Health Check

## Запуск

```bash
# Запуск всех сервисов
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down
```

## Тестирование

```bash
# Health check API Gateway
curl http://localhost/api/health

# Проверка маршрутизации через Gateway
curl http://localhost/api/users

# Прямой доступ к Keycloak
curl http://localhost/auth/realms/master
```

## Конфигурация

- **Nginx**: `nginx/nginx.conf`
- **Ocelot**: `../../src/Gateway.Api/ocelot.json`
- **Docker Compose**: `docker-compose.yml` 
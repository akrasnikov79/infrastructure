# Gateway API - Build and Deploy Guide

Этот документ описывает как собирать и публиковать Docker образ Gateway API в GitHub Container Registry.

## Предварительные требования

1. **Docker** установлен и запущен
2. **GitHub Personal Access Token** с правами на packages:write
3. **Git** (для автоматического тегирования версий)

## Настройка GitHub Token

### Windows PowerShell:
```powershell
$env:GITHUB_TOKEN = "ghp_your_token_here"
```

### Linux/macOS:
```bash
export GITHUB_TOKEN="ghp_your_token_here"
```

### Постоянное сохранение (Linux/macOS):
```bash
echo 'export GITHUB_TOKEN="ghp_your_token_here"' >> ~/.bashrc
source ~/.bashrc
```

## Способы сборки и публикации

### 1. Makefile (Рекомендуется)

Показать все доступные команды:
```bash
make help
```

Основные команды:
```bash
# Собрать образ
make build

# Собрать и опубликовать
make push

# Собрать и опубликовать с версией
make push VERSION=v1.0.0

# Быстрая публикация с автоопределением версии из git тегов
make quick-push

# Тестирование локально
make test

# Запуск локально
make run

# Очистка образов
make clean

# Development версии
make dev-build
make dev-push
```

### 2. PowerShell Script (Windows)

```powershell
# Сборка и публикация latest
./build-and-push.ps1

# Сборка и публикация с версией
./build-and-push.ps1 -Version "v1.0.0"

# С кастомными параметрами
./build-and-push.ps1 -Version "v1.0.0" -ImageName "my-gateway" -Username "myuser"
```

### 3. Bash Script (Linux/macOS)

```bash
# Сделать скрипт исполняемым
chmod +x build-and-push.sh

# Сборка и публикация latest
./build-and-push.sh

# Сборка и публикация с версией
./build-and-push.sh v1.0.0
```

### 4. Прямые Docker команды

```bash
# Login
echo $GITHUB_TOKEN | docker login ghcr.io -u akrasnikov79 --password-stdin

# Build
docker build -t ghcr.io/akrasnikov79/gateway-service:latest .

# Push
docker push ghcr.io/akrasnikov79/gateway-service:latest
```

## Управление версиями

### Использование Git тегов:
```bash
# Создать тег
git tag v1.0.0
git push origin v1.0.0

# Автоматически использовать тег для версии
make quick-push
```

### Ручное указание версии:
```bash
make push VERSION=v1.0.0
./build-and-push.sh v1.0.0
./build-and-push.ps1 -Version "v1.0.0"
```

## Локальное тестирование

### Запуск для тестирования:
```bash
make test
# или
docker run --rm -p 5001:8080 ghcr.io/akrasnikov79/gateway-service:latest
```

### Проверка health check:
```bash
curl http://localhost:5001/api/health
```

### Проверка Ocelot конфигурации:
```bash
curl http://localhost:5001/api/users
```

## Использование в Docker Compose

Образ автоматически будет использован в `deploy/proxy/docker-compose.yml`:

```yaml
gateway-api:
  image: ghcr.io/akrasnikov79/gateway-service:latest
  # ... остальная конфигурация
```

## Troubleshooting

### Ошибка авторизации:
- Проверьте, что `GITHUB_TOKEN` установлен правильно
- Убедитесь, что токен имеет права `packages:write`

### Ошибка сборки:
- Убедитесь, что вы находитесь в папке `src/Gateway.Api`
- Проверьте, что все файлы проекта присутствуют

### Образ не запускается:
- Проверьте логи: `docker logs <container_name>`
- Убедитесь, что `ocelot.json` корректен

## Автоматизация в CI/CD

Для GitHub Actions можно использовать:
```yaml
- name: Build and Push
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: make push
``` 
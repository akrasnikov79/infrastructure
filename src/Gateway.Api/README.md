# Gateway API - Ocelot API Gateway

Этот проект представляет собой API Gateway, построенный на основе Ocelot для .NET, который обеспечивает маршрутизацию запросов к различным микросервисам.

## Особенности

- ✅ Маршрутизация API запросов
- ✅ Поддержка CORS
- ✅ Health Check endpoint
- ✅ Интеграция с Keycloak для аутентификации
- ✅ Конфигурация через JSON
- ✅ Docker поддержка
- ✅ Автоматическое управление версиями

## Конфигурация

Конфигурация маршрутизации находится в файле `ocelot.json`:

```json
{
  "Routes": [
    {
      "UpstreamPathTemplate": "/api/auth/{everything}",
      "DownstreamPathTemplate": "/auth/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        {
          "Host": "keycloak",
          "Port": 8080
        }
      ]
    }
  ]
}
```

## Запуск локально

```bash
dotnet run
```

API будет доступен по адресу: `http://localhost:5000`

## Docker

### Сборка и публикация образа

Для сборки и публикации Docker образа в GitHub Container Registry используйте один из скриптов:

**Windows PowerShell:**
```powershell
# Сборка с тегом latest
.\build-and-push.ps1

# Сборка с определенной версией
.\build-and-push.ps1 "v1.0.0"

# Сборка с версией и датой
.\build-and-push.ps1 "v1.0.0-$(Get-Date -Format 'yyyyMMdd')"
```

**Windows Command Prompt:**
```cmd
# Сборка с тегом latest
build-and-push.bat

# Сборка с определенной версией
build-and-push.bat v1.0.0

# Сборка с версией и датой
build-and-push.bat v1.0.0-20241215
```

**Linux/macOS:**
```bash
# Сборка с тегом latest
chmod +x build-and-push.sh
./build-and-push.sh

# Сборка с определенной версией
./build-and-push.sh v1.0.0

# Сборка с версией и датой
./build-and-push.sh "v1.0.0-$(date +%Y%m%d)"
```

### Конфигурация скриптов

Все скрипты содержат следующие переменные конфигурации:

- **REGISTRY**: `ghcr.io` - GitHub Container Registry
- **USERNAME**: `akrasnikov79` - имя пользователя GitHub
- **IMAGE_NAME**: `gateway-service` - имя Docker образа
- **VERSION**: версия образа (по умолчанию `latest`)
- **FULL_IMAGE_PATH**: полный путь к образу в реестре

### Примеры использования

```bash
# Сборка development версии
./build-and-push.sh dev

# Сборка production версии
./build-and-push.sh v1.2.3

# Сборка с build номером
./build-and-push.sh "v1.2.3-build.$(date +%Y%m%d.%H%M%S)"
```

### Ручная сборка

```bash
# Сборка образа
docker build -t gateway-api .

# Запуск контейнера
docker run -p 5000:8080 gateway-api
```

## Endpoints

- `GET /api/health` - Health check
- `GET /api/auth/*` - Проксирование к Keycloak
- `GET /api/users/*` - Проксирование к Users Service
- `GET /api/clients/*` - Проксирование к Clients Service

## Тестирование

```bash
# Health check
curl http://localhost:5000/api/health

# Проверка маршрутизации
curl http://localhost:5000/api/users
```

## Развертывание

Проект автоматически развертывается через Docker Compose в составе инфраструктуры прокси-сервера.

```bash
cd ../../deploy/proxy
docker-compose up -d
```

## Управление версиями

Скрипты поддерживают семантическое версионирование:

- `latest` - последняя версия (по умолчанию)
- `v1.0.0` - конкретная версия
- `v1.0.0-dev` - версия для разработки
- `v1.0.0-20241215` - версия с датой

При указании версии отличной от `latest`, автоматически создается дополнительный тег `latest`.

## Структура проекта

```
Gateway.Api/
├── Program.cs              # Точка входа приложения
├── ocelot.json             # Конфигурация маршрутизации
├── Dockerfile              # Docker образ
├── build-and-push.ps1      # PowerShell скрипт для сборки
├── build-and-push.bat      # Batch скрипт для сборки
├── build-and-push.sh       # Bash скрипт для сборки
└── README.md              # Этот файл
```

## Автоматизация CI/CD

Скрипты можно интегрировать с CI/CD пайплайнами:

**GitHub Actions:**
```yaml
- name: Build and Push Docker Image
  run: |
    chmod +x ./build-and-push.sh
    ./build-and-push.sh "v${{ github.run_number }}"
```

**Azure DevOps:**
```yaml
- script: |
    .\build-and-push.ps1 "v$(Build.BuildNumber)"
  displayName: 'Build and Push Docker Image'
``` 
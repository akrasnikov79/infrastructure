# Примеры использования скриптов сборки

## Основные сценарии использования

### 1. Сборка версии для разработки

```powershell
# PowerShell
.\build-and-push.ps1 "dev"
```

```bash
# Bash
./build-and-push.sh dev
```

**Результат:**
- Создается образ: `ghcr.io/akrasnikov79/gateway-service:dev`
- Также создается тег: `ghcr.io/akrasnikov79/gateway-service:latest`

### 2. Сборка релизной версии

```powershell
# PowerShell
.\build-and-push.ps1 "v1.0.0"
```

```cmd
# Batch
build-and-push.bat v1.0.0
```

**Результат:**
- Создается образ: `ghcr.io/akrasnikov79/gateway-service:v1.0.0`
- Также создается тег: `ghcr.io/akrasnikov79/gateway-service:latest`

### 3. Сборка с датой

```bash
# Bash - с текущей датой
./build-and-push.sh "v1.0.0-$(date +%Y%m%d)"
```

```powershell
# PowerShell - с текущей датой
.\build-and-push.ps1 "v1.0.0-$(Get-Date -Format 'yyyyMMdd')"
```

**Результат:**
- Создается образ: `ghcr.io/akrasnikov79/gateway-service:v1.0.0-20241215`
- Также создается тег: `ghcr.io/akrasnikov79/gateway-service:latest`

### 4. Сборка с временной меткой

```bash
# Bash - с датой и временем
./build-and-push.sh "v1.0.0-build.$(date +%Y%m%d.%H%M%S)"
```

```powershell
# PowerShell - с датой и временем
.\build-and-push.ps1 "v1.0.0-build.$(Get-Date -Format 'yyyyMMdd.HHmmss')"
```

**Результат:**
- Создается образ: `ghcr.io/akrasnikov79/gateway-service:v1.0.0-build.20241215.143022`
- Также создается тег: `ghcr.io/akrasnikov79/gateway-service:latest`

### 5. Сборка latest версии

```bash
# Без параметров - создает latest
./build-and-push.sh
```

```powershell
# Без параметров - создает latest
.\build-and-push.ps1
```

**Результат:**
- Создается только образ: `ghcr.io/akrasnikov79/gateway-service:latest`

## Интеграция с CI/CD

### GitHub Actions

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Build and Push - Development
      if: github.event_name == 'pull_request'
      run: |
        chmod +x ./build-and-push.sh
        ./build-and-push.sh "dev-${{ github.run_number }}"
    
    - name: Build and Push - Production
      if: github.ref == 'refs/heads/main'
      run: |
        chmod +x ./build-and-push.sh
        ./build-and-push.sh "v1.0.${{ github.run_number }}"
```

### Azure DevOps

```yaml
trigger:
- main

pool:
  vmImage: 'windows-latest'

steps:
- task: PowerShell@2
  displayName: 'Build and Push Docker Image'
  inputs:
    targetType: 'inline'
    script: |
      if ($env:BUILD_SOURCEBRANCH -eq "refs/heads/main") {
        .\build-and-push.ps1 "v1.0.$(Build.BuildNumber)"
      } else {
        .\build-and-push.ps1 "dev-$(Build.BuildNumber)"
      }
    workingDirectory: 'src/Gateway.Api'
```

### Jenkins

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build and Push') {
            steps {
                script {
                    def version = env.BRANCH_NAME == 'main' ? 
                        "v1.0.${env.BUILD_NUMBER}" : 
                        "dev-${env.BUILD_NUMBER}"
                    
                    sh "chmod +x ./build-and-push.sh"
                    sh "./build-and-push.sh ${version}"
                }
            }
        }
    }
}
```

## Просмотр созданных образов

```bash
# Просмотр всех тегов образа
docker images ghcr.io/akrasnikov79/gateway-service

# Просмотр информации об образе
docker inspect ghcr.io/akrasnikov79/gateway-service:v1.0.0

# Запуск конкретной версии
docker run -p 5000:8080 ghcr.io/akrasnikov79/gateway-service:v1.0.0
```

## Использование в Docker Compose

```yaml
version: '3.9'
services:
  gateway-api:
    image: ghcr.io/akrasnikov79/gateway-service:v1.0.0  # Конкретная версия
    # или
    # image: ghcr.io/akrasnikov79/gateway-service:latest  # Последняя версия
    container_name: gateway-api
    ports:
      - "5000:8080"
    networks:
      - infrastructure-network
```

## Конфигурация переменных

Для изменения настроек отредактируйте переменные в начале скрипта:

```powershell
# PowerShell
$REGISTRY = "ghcr.io"                    # Реестр Docker
$USERNAME = "akrasnikov79"               # Имя пользователя GitHub
$IMAGE_NAME = "gateway-service"          # Имя образа
$TOKEN = "your-github-token"             # Токен GitHub
```

```bash
# Bash
REGISTRY="ghcr.io"
USERNAME="akrasnikov79"
IMAGE_NAME="gateway-service"
TOKEN="your-github-token"
```

## Отладка

Для отладки процесса сборки используйте:

```bash
# Просмотр логов Docker
docker logs gateway-api

# Проверка образов
docker images | grep gateway-service

# Тестирование локально
docker run --rm -p 5001:8080 ghcr.io/akrasnikov79/gateway-service:v1.0.0
``` 
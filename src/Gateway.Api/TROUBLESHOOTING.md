# Руководство по решению проблем

## Проблема: Ошибка выполнения PowerShell скриптов

### Описание ошибки
```
.\build-and-push.ps1 : Невозможно загрузить файл F:\project\infrastructure\src\Gateway.Api\build-and-push.ps1, так как выполнение сценариев отключено в этой системе.
```

### Решения

#### 1. Изменение политики выполнения PowerShell (Рекомендуется)

```powershell
# Для текущего пользователя (рекомендуется)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Для всей системы (требуются права администратора)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

**Проверка текущей политики:**
```powershell
Get-ExecutionPolicy -List
```

#### 2. Временное разрешение для одного скрипта

```powershell
PowerShell -ExecutionPolicy Bypass -File .\build-and-push.ps1 "v1.0.0"
```

#### 3. Использование альтернативных скриптов

**Windows Batch (не требует изменения политики):**
```cmd
build-and-push.bat v1.0.0
```

**Git Bash / WSL:**
```bash
chmod +x build-and-push.sh
./build-and-push.sh v1.0.0
```

#### 4. Выполнение команд напрямую

```powershell
# Переменные конфигурации
$REGISTRY = "ghcr.io"
$USERNAME = "akrasnikov79"
$IMAGE_NAME = "gateway-service"
$VERSION = "v1.0.0"
$FULL_IMAGE_PATH = "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"
$TOKEN = ""

# Выполнение команд
echo $TOKEN | docker login $REGISTRY -u $USERNAME --password-stdin
docker build -t $FULL_IMAGE_PATH .
docker push $FULL_IMAGE_PATH

# Если версия не latest, также создаем latest тег
if ($VERSION -ne "latest") {
    $LATEST_IMAGE_PATH = "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"
    docker tag $FULL_IMAGE_PATH $LATEST_IMAGE_PATH
    docker push $LATEST_IMAGE_PATH
}
```

## Проблема: Ошибки Docker

### Docker не запущен
```
error during connect: This error may indicate that the docker daemon is not running.
```

**Решение:**
```bash
# Запустить Docker Desktop
# Или проверить статус службы Docker
Get-Service docker
```

### Нет доступа к Docker Hub/GHCR
```
denied: requested access to the resource is denied
```

**Решение:**
```bash
# Проверить авторизацию
docker login ghcr.io -u akrasnikov79

# Проверить токен GitHub
# Убедиться, что токен имеет права: write:packages, read:packages
```

## Проблема: Ошибки сборки .NET

### Ошибка восстановления пакетов
```
error NU1301: Unable to load the service index for source
```

**Решение:**
```bash
# Очистить кеш NuGet
dotnet nuget locals all --clear

# Восстановить пакеты
dotnet restore --no-cache
```

### Ошибка компиляции
```
error CS0246: The type or namespace name 'Ocelot' could not be found
```

**Решение:**
```bash
# Убедиться, что пакет Ocelot установлен
dotnet add package Ocelot
dotnet restore
```

## Проблема: Ошибки развертывания

### Порт уже используется
```
ERROR: for gateway-api  Cannot start service gateway-api: driver failed programming external connectivity on endpoint gateway-api: Bind for 0.0.0.0:5000 failed: port is already allocated
```

**Решение:**
```bash
# Найти процесс, использующий порт
netstat -ano | findstr :5000

# Остановить процесс
taskkill /PID <PID> /F

# Или изменить порт в docker-compose.yml
ports:
  - "5001:8080"  # Изменить на свободный порт
```

### Контейнер не запускается
```
ERROR: for gateway-api  Container "..." is unhealthy.
```

**Решение:**
```bash
# Просмотр логов контейнера
docker logs gateway-api

# Проверка статуса
docker ps -a

# Перезапуск контейнера
docker-compose restart gateway-api
```

## Проблема: Ошибки сети

### Контейнеры не могут общаться
```
System.Net.Http.HttpRequestException: Connection refused
```

**Решение:**
```bash
# Проверить сети Docker
docker network ls

# Создать сеть, если не существует
docker network create infrastructure-network

# Проверить подключение контейнеров к сети
docker network inspect infrastructure-network
```

## Полезные команды для диагностики

### Проверка Docker
```bash
# Версия Docker
docker version

# Информация о системе
docker system info

# Просмотр образов
docker images

# Просмотр контейнеров
docker ps -a

# Просмотр логов
docker logs <container_name>
```

### Проверка .NET
```bash
# Версия .NET
dotnet --version

# Список установленных SDK
dotnet --list-sdks

# Восстановление проекта
dotnet restore

# Сборка проекта
dotnet build
```

### Проверка сети
```bash
# Тест подключения к контейнеру
docker exec -it gateway-api ping keycloak

# Тест HTTP запроса
curl http://localhost:5000/api/health
```

## Рекомендации по безопасности

1. **Никогда не коммитьте токены в репозиторий**
2. **Используйте переменные окружения для конфиденциальных данных**
3. **Регулярно обновляйте токены доступа**
4. **Используйте минимальные права доступа**

### Использование переменных окружения

```powershell
# Установить переменную окружения
$env:GITHUB_TOKEN = "your-token-here"

# Использовать в скрипте
$TOKEN = $env:GITHUB_TOKEN
```

```bash
# Bash
export GITHUB_TOKEN="your-token-here"
TOKEN="$GITHUB_TOKEN"
```

## Получение помощи

1. **Документация Docker:** https://docs.docker.com/
2. **Документация .NET:** https://docs.microsoft.com/dotnet/
3. **Документация Ocelot:** https://ocelot.readthedocs.io/
4. **Документация GitHub Packages:** https://docs.github.com/packages 
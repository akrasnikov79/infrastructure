# Makefile for Gateway API Docker operations

REGISTRY = ghcr.io
USERNAME = akrasnikov79
IMAGE_NAME = gateway-service
VERSION ?= latest
FULL_IMAGE_NAME = $(REGISTRY)/$(USERNAME)/$(IMAGE_NAME):$(VERSION)

.PHONY: help build push login clean test run

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build Docker image
	@echo "Building Docker image: $(FULL_IMAGE_NAME)"
	docker build -t $(FULL_IMAGE_NAME) .

login: ## Login to GitHub Container Registry
	@echo "Logging in to $(REGISTRY)..."
	@if [ -z "$(GITHUB_TOKEN)" ]; then \
		echo "Error: GITHUB_TOKEN environment variable is not set!"; \
		echo "Set it with: export GITHUB_TOKEN='your_token_here'"; \
		exit 1; \
	fi
	@echo "$(GITHUB_TOKEN)" | docker login $(REGISTRY) -u $(USERNAME) --password-stdin

push: login build ## Build and push Docker image
	@echo "Pushing Docker image: $(FULL_IMAGE_NAME)"
	docker push $(FULL_IMAGE_NAME)
	@if [ "$(VERSION)" != "latest" ]; then \
		echo "Tagging as latest..."; \
		docker tag $(FULL_IMAGE_NAME) $(REGISTRY)/$(USERNAME)/$(IMAGE_NAME):latest; \
		docker push $(REGISTRY)/$(USERNAME)/$(IMAGE_NAME):latest; \
	fi

test: build ## Test Docker image locally
	@echo "Testing Docker image locally on port 5001..."
	docker run --rm -p 5001:8080 --name gateway-test $(FULL_IMAGE_NAME)

run: build ## Run Docker image locally
	@echo "Running Docker image locally on port 5000..."
	docker run --rm -p 5000:8080 --name gateway-api $(FULL_IMAGE_NAME)

clean: ## Clean up Docker images
	@echo "Cleaning up Docker images..."
	docker rmi $(FULL_IMAGE_NAME) || true
	docker rmi $(REGISTRY)/$(USERNAME)/$(IMAGE_NAME):latest || true
	docker system prune -f

# Quick commands
quick-push: ## Quick build and push with version from git tag or latest
	@VERSION=$$(git describe --tags --abbrev=0 2>/dev/null || echo "latest") $(MAKE) push

# Development commands
dev-build: ## Build with development tag
	$(MAKE) build VERSION=dev

dev-push: ## Push development version
	$(MAKE) push VERSION=dev 
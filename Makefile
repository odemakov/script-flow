# Makefile

.PHONY: build dev test clean extract

DOCKER_COMPOSE=docker compose
DOCKER=docker
PROJECT_NAME=scriptflow
BUILD_OUTPUT=scriptflow

# Run development environment
dev:
	$(DOCKER_COMPOSE) -f docker-compose.yml up --build

# Create migration file
create_migration_snapshot:
	$(DOCKER_COMPOSE) -f docker-compose.yml exec backend go run . migrate history-sync
	$(DOCKER_COMPOSE) -f docker-compose.yml exec backend go run . migrate collections

# Stop dev stack
stop:
	$(DOCKER_COMPOSE) -f docker-compose.yml stop

# Run unit tests for frontend and backend
test: _test_backend _test_frontend
_test_backend:
	@echo $(DOCKER) run --rm -v $(PWD)/backend:/app -w /app golang:1.23-alpine go test ./...
_test_frontend:
	$(DOCKER) build --no-cache --target builder-frontend -t $(PROJECT_NAME):builder-frontend .
	$(DOCKER) run --rm $(PROJECT_NAME):builder-frontend npm run test

# Stop all containers and clean up
clean:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

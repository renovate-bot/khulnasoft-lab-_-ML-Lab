.PHONY: install test lint build clean docker-build docker-run

# Development commands
install:
	pip install -r build_requirements.txt
	cd webapp && yarn install

test:
	python build.py --test

lint:
	python build.py --check

build:
	python build.py --make

clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -r {} +
	find . -type d -name "*.egg" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	find . -type d -name ".coverage" -exec rm -r {} +
	find . -type d -name "htmlcov" -exec rm -r {} +
	find . -type d -name "dist" -exec rm -r {} +
	find . -type d -name "build" -exec rm -r {} +

# Docker commands
docker-build:
	docker build -t lab-backend .
	cd webapp && yarn build
	docker build -t lab-workspace-manager ./components/lab-workspace-manager

docker-run:
	cd deployment/mllab-docker && docker-compose up

# Development environment
dev-setup: install
	pre-commit install

# Help command
help:
	@echo "Available commands:"
	@echo "  make install      - Install dependencies"
	@echo "  make test         - Run tests"
	@echo "  make lint         - Run linting"
	@echo "  make build        - Build the project"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make docker-build - Build Docker images"
	@echo "  make docker-run   - Run Docker containers"
	@echo "  make dev-setup    - Set up development environment"

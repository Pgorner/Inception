ENV_FILE := ./srcs/.env
DATA := ./data

all: check-docker $(ENV_FILE) $(DATA) up

up:
	@docker-compose -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re: clean
	@$(MAKE) all

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs

clean:
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\

check-docker:
	@if ! docker info >/dev/null 2>&1; then \
		echo "Docker is not running. Starting Docker..."; \
		dockerd & \
		sleep 15; \
	fi

$(ENV_FILE):
	@echo "Please create the .env file at $(ENV_FILE) with the required environment variables."
	@exit 1

$(DATA):
	mkdir -p $(HOME)/data/wordpress_db
	mkdir -p $(HOME)/data/wordpress_files

.PHONY: all re down clean check-docker logs

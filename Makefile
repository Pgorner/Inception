# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pgorner <pgorner@student.42heilbronn.de    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/28 16:11:11 by pgorner           #+#    #+#              #
#    Updated: 2023/09/28 18:14:17 by pgorner          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ENV_FILE := ./srcs/.env
DATA := ./data

all: check-docker $(ENV_FILE) $(DATA) up

up:
	@docker compose -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

down:
	@docker compose -f ./srcs/docker-compose.yml down

re: clean
	all

logs:
	@docker compose -f ./srcs/docker-compose.yml logs

clean:
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\

check-docker:
	@if ! docker info >/dev/null 2>&1; then \
		echo "Docker is not running. Starting Docker..."; \
		open --background -a Docker || (echo "Please start Docker manually" && exit 1); \
		sleep 15; \
	fi

$(ENV_FILE):
	@echo "Please create the .env file at $(ENV_FILE) with the required environment variables."
	@exit 1
	
$(DATA):
	mkdir -p $(HOME)/data/wordpress_db
	mkdir -p $(HOME)/data/wordpress_files


.PHONY: all re down clean check-docker logs

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pgorner <pgorner@student.42heilbronn.de    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/28 16:11:11 by pgorner           #+#    #+#              #
#    Updated: 2023/09/30 14:20:40 by pgorner          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ENV_FILE := ./srcs/.env
DATA := ./data

all: $(ENV_FILE) $(DATA) up

up:
	@sudo docker compose -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

down:
	@sudo docker compose -f ./srcs/docker-compose.yml down

re: clean
	all

logs:
	@sudo docker compose -f ./srcs/docker-compose.yml logs

clean:
	@sudo docker stop $$(docker ps -qa);\
	@sudo rm -rf $(HOME)/data/wordpress_db
	@sudo rm -rf $(HOME)/data/wordpress_files
	@sudo docker system prune --all --force --volumes
	@sudo docker volume prune --force
	@sudo docker network prune --force
	@sudo docker volume rm `sudo docker volume ls -q`
	@echo "MADE CLEAN"


$(ENV_FILE):
	@echo "Please create the .env file at $(ENV_FILE) with the required environment variables."
	@exit 1
	
$(DATA):
	mkdir -p $(HOME)/data/wordpress_db
	mkdir -p $(HOME)/data/wordpress_files


.PHONY: all re down clean logs
